#!/bin/bash
# This script is only for DRY

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi

}
DOWNLOAD() {
  echo downloading ${COMPONENT} application content
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG}
  StatusCheck
}
APP_USER_SETUP() {
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    echo Adding Application User
    useradd roboshop &>>${LOG}
    StatusCheck
  fi
}

APP_CLEAN() {
  echo Cleaning the old application content
  cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
  StatusCheck

  echo extracting application archive
  unzip /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG} && cd ${COMPONENT} &>>${LOG}
  StatusCheck
}
SYSTEMD() {
  echo configuring ${COMPONENT} SystemD service
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG} && systemctl daemon-reload &>>${LOG}
  StatusCheck

  echo starting ${COMPONENT} service
  systemctl start ${COMPONENT} &>>${LOG} && systemctl enable ${COMPONENT} &>>${LOG}
  StatusCheck
}

NODEJS() {
  echo Setting nodejs repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  StatusCheck

  echo installing NodeJs
  yum install nodejs -y &>>${LOG}
  StatusCheck

  APP_USER_SETUP
  DOWNLOAD

  APP_CLEAN

  echo installing NodeJs Dependencies
  npm install &>>${LOG}
  StatusCheck
  SYSTEMD

}

JAVA() {
  echo Install Maven
  yum install maven -y &>>${LOG}
  StatusCheck

  APP_USER_SETUP
  DOWNLOAD
  APP_CLEAN

  echo Make Application Package
  mvn clean package &>>${LOG} && mv target/shipping-1.0.jar shipping.jar &>>${LOG}
  StatusCheck

  SYSTEMD

}

PYTHON() {
  echo Install Python
  yum install python36 gcc python3-devel -y &>>{LOG}
  StatusCheck

  APP_USER_SETUP
  DOWNLOAD
  APP_CLEAN

  echo Install Python Dependencies
  cd /home/roboshop/payment &>>{LOG} && pip3 install -r requirements.txt &>>{LOG}
  StatusCheck

  SYSTEMD
}

USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31mYou should be a root user to run this script or sudo\e[0m"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}
