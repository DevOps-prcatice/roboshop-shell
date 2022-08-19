set -e
yum install maven -y &>>/tmp/shiiping.log
useradd roboshop &>>/tmp/shiiping.log
cd /home/roboshop &>>/tmp/shiiping.log
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>/tmp/shiiping.log
unzip -o /tmp/shipping.zip &>>/tmp/shiiping.log
mv shipping-main shipping &>>/tmp/shiiping.log
cd shipping &>>/tmp/shiiping.log
mvn clean package &>>/tmp/shiiping.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/shiiping.log
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service &>>/tmp/shiiping.log
systemctl daemon-reload &>>/tmp/shiiping.log
systemctl start shipping &>>/tmp/shiiping.log
systemctl enable shipping &>>/tmp/shiiping.log