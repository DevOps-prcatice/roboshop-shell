set -e
yum install python36 gcc python3-devel -y &>>/tmp/payment.log
useradd roboshop &>>/tmp/payment.log
cd /home/roboshop &>>/tmp/payment.log
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip" &>>/tmp/payment.log
unzip -o /tmp/payment.zip &>>/tmp/payment.log
mv payment-main payment &>>/tmp/payment.log
cd /home/roboshop/payment &>>/tmp/payment.log
pip3 install -r requirements.txt &>>/tmp/payment.log
mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service &>>/tmp/payment.log
systemctl daemon-reload &>>/tmp/payment.log
systemctl enable payment &>>/tmp/payment.log
systemctl start payment &>>/tmp/payment.log