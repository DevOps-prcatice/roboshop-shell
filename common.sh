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
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>/tmp/${COMPONENT}.log
  StatusCheck
}
NODEJS() {
  echo Setting nodejs repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/${COMPONENT}.log
  StatusCheck

  echo installing NodeJs
  yum install nodejs -y &>>/tmp/${COMPONENT}.log
  StatusCheck

  id roboshop &>>/tmp/${COMPONENT}.log
  if [ $? -ne 0 ]; then
    echo Adding Application User
    useradd roboshop &>>/tmp/${COMPONENT}.log
    StatusCheck
  fi

  DOWNLOAD

  echo Cleaning the old application content
  cd /home/roboshop &>>/tmp/${COMPONENT}.log && rm -rf ${COMPONENT} &>>/tmp/${COMPONENT}.log
  StatusCheck

  echo extracting application archive
  unzip /tmp/${COMPONENT}.zip &>>/tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} &>>/tmp/${COMPONENT}.log && cd ${COMPONENT} &>>/tmp/${COMPONENT}.log
  StatusCheck

  echo installing NodeJs Dependencies
  npm install &>>/tmp/${COMPONENT}.log
  StatusCheck

  echo configuring ${COMPONENT} SystemD service
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>/tmp/${COMPONENT}.log && systemctl daemon-reload &>>/tmp/${COMPONENT}.log
  StatusCheck

  echo starting ${COMPONENT} service
  systemctl start ${COMPONENT} &>>/tmp/${COMPONENT}.log && systemctl enable ${COMPONENT} &>>/tmp/${COMPONENT}.log
  StatusCheck
}
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[31mYou should be a root user to run this script or sudo\e[0m"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -f ${LOG}
