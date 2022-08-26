#!/bin/bash
#Roboshop Front end

COMPONENT=frontend
source common.sh

echo Installing Nginx
yum install nginx -y &>>${LOG}
StatusCheck

DOWNLOAD

echo Clean Old Content
cd /usr/share/nginx/html &>>${LOG} && rm -rf * &>>${LOG}
StatusCheck

echo extract Download Content
unzip -o /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main/static/* . && mv ${COMPONENT}-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
StatusCheck

echo Start Nginx Service
systemctl restart nginx &>>${LOG} && systemctl enable nginx &>>${LOG}
