set -o
yum install golang -y &>>/tmp/dispatch.log
useradd roboshop &>>/tmp/dispatch.log
curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip &>>/tmp/dispatch.log
unzip -o /tmp/dispatch.zip &>>/tmp/dispatch.log
mv dispatch-main dispatch &>>/tmp/dispatch.log
cd dispatch &>>/tmp/dispatch.log
go mod init dispatch &>>/tmp/dispatch.log
go get &>>/tmp/dispatch.log
go build &>>/tmp/dispatch.log
mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service &>>/tmp/dispatch.log
systemctl daemon-reload &>>/tmp/dispatch.log
systemctl enable dispatch &>>/tmp/dispatch.log
systemctl start dispatch &>>/tmp/dispatch.log