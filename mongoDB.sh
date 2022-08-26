#!/usr/bin/bash

COMPONENT=mongodb
source common.sh

echo Setup Yum Repo
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
StatusCheck

echo Install MongoDB
yum install -y mongodb-org &>>{LOG}
StatusCheck

echo Start MongoDB Service
systemctl enable mongod &>>{LOG} && systemctl start mongod &>>{LOG}
StatusCheck

# Update Listen Config
#systemctl restart mongod

DOWNLOAD

echo Extract Schema file
cd /tmp && unzip -o mongodb.zip &>>{LOG}
StatusCheck

echo Load Schema
cd mongodb-main &>>{LOG} && mongo < catalogue.js &>>{LOG} && mongo < users.js &>>{LOG}
StatusCheck

