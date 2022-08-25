COMPONENT="${LOG}"
source common.sh

echo Setting nodejs repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash ${LOG}
StatusCheck

echo installing NodeJs
yum install nodejs -y ${LOG}
StatusCheck

UserStatus    # Add Application user if he doesn't exist already

echo downloading application content
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" ${LOG} && cd /home/roboshop ${LOG}
StatusCheck

echo Cleaning the old application content
rm -rf cart ${LOG}
StatusCheck

echo extracting application archive
unzip /tmp/cart.zip ${LOG} && mv cart-main cart ${LOG} && cd cart ${LOG}
StatusCheck

echo installing NodeJs Dependencies
npm install ${LOG}
StatusCheck

echo configuring Cart SystemD service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service ${LOG} && systemctl daemon-reload ${LOG}
StatusCheck

echo starting cart service
systemctl start cart ${LOG} && systemctl enable cart ${LOG}
StatusCheck
