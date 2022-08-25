source common.sh

echo -e "\e[32mSetting nodejs repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/cart.log
echo $?
echo -e "\e[32m installing NodeJs \e[0m"
yum install nodejs -y &>>/tmp/cart.log
echo $?
echo -e "\e[32m Adding user roboshop \e[0m"
useradd roboshop &>>/tmp/cart.log
echo $?
echo -e "\e[32mdownloading application content\e[0m"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/cart.log
echo $?
cd /home/roboshop &>>/tmp/cart.log
echo $?
echo Cleaning the old application content
rm -rf cart &>>/tmp/cart.log
echo $?
echo extracting application archive
unzip /tmp/cart.zip &>>/tmp/cart.log
echo $?
mv cart-main cart &>>/tmp/cart.log
echo $?
cd cart &>>/tmp/cart.log
echo $?
echo installing NodeJs Dependencies
npm install &>>/tmp/cart.log
echo $?
echo configuring Cart SystemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service &>>/tmp/cart.log
echo $?
systemctl daemon-reload &>>/tmp/cart.log
echo $?
echo starting cart service
systemctl start cart &>>/tmp/cart.log
echo $?
systemctl enable cart &>>/tmp/cart.log
echo $?


