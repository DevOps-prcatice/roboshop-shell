set -e
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/rabbitmq.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/rabbitmq.log
yum install rabbitmq-server -y &>>/tmp/rabbitmq.log
systemctl enable rabbitmq-server &>>/tmp/rabbitmq.log
systemctl start rabbitmq-server &>>/tmp/rabbitmq.log
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/rabbitmq.log
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/rabbitmq.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/rabbitmq.log