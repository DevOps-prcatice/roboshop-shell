source common.sh

echo  Setting nodejs repos 
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
echo $?

echo   installing NodeJs 
yum install nodejs -y &>>/tmp/cart.log
echo $?

echo   Adding Application User
useradd roboshop &>>/tmp/cart.log
echo $?

echo  downloading application content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/cart.log
cd /home/roboshop &>>/tmp/cart.log
echo $?

echo Cleaning the old application content
rm -rf cart &>>/tmp/cart.log
echo $?

echo extracting application archive
unzip /tmp/cart.zip &>>/tmp/cart.log
mv cart-main cart &>>/tmp/cart.log
cd cart &>>/tmp/cart.log
echo $?

echo installing NodeJs Dependencies
npm install &>>/tmp/cart.log
echo $?

echo configuring Cart SystemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
systemctl daemon-reload &>>/tmp/cart.log
echo $?

echo starting cart service
systemctl start cart &>>/tmp/cart.log
systemctl enable cart &>>/tmp/cart.log
echo $?


