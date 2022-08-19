set -e
echo setting nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
echo installing NodeJs
yum install nodejs -y &>>/tmp/cart.log

echo Adding user roboshop
useradd roboshop &>>/tmp/cart.log

echo downloading application content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/cart.log
cd /home/roboshop &>>/tmp/cart.log

echo Cleaning the old application content
rm -rf cart &>>/tmp/cart.log

echo extracting application archive
unzip -o /tmp/cart.zip &>>/tmp/cart.log
mv cart-main cart &>>/tmp/cart.log
cd cart &>>/tmp/cart.log

echo installing NodeJs Dependencies
npm install &>>/tmp/cart.log

echo configuring Cart SystemD service
mv /home/roboshop/cart/systemd.service /etc/
systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log

echo starting cart service
systemctl start cart &>>/tmp/cart.log
systemctl enable cart &>>/tmp/cart.log