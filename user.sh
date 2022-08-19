set -e

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/user.log

yum install nodejs -y &>>/tmp/user.log
useradd roboshop &>>/tmp/user.log
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>/tmp/user.log
cd /home/roboshop &>>/tmp/user.log
rm -rf User &>>/tmp/user.log
unzip -o /tmp/user.zip &>>/tmp/user.log
mv user-main user &>>/tmp/user.log
cd /home/roboshop/user &>>/tmp/user.log
npm install &>>/tmp/user.log
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>/tmp/user.log
systemctl daemon-reload &>>/tmp/user.log
systemctl start user &>>/tmp/user.log
systemctl enable user &>>/tmp/user.log