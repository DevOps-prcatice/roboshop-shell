COMPONENT=rabbitmq
source common.sh

if [ -z "$RABBITMQ_APP_PASSWORD" ]; then
  echo -e "\e[33menv variable RABBITMQ_APP_PASSWORD is needed\e[0m"
  exit 1
fi
echo Setup YUM Repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
StatusCheck

echo "Install RabbitMQ & Erlang"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG}
StatusCheck

echo Start RabbitMQ Service
systemctl enable rabbitmq-server &>>${LOG} && systemctl start rabbitmq-server &>>${LOG}
StatusCheck

sudo rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  echo Add App User in RabbitMQ
  rabbitmqctl add_user roboshop ${RABBITMQ_APP_PASSWORD} &>>${LOG} && rabbitmqctl set_user_tags roboshop administrator &>>${LOG} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
  StatusCheck
fi
