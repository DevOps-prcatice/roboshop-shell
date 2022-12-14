COMPONENT=redis
source common.sh


echo Setup Yum Repo
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>{LOG}
StatusCheck

echo Install Redis
yum install redis-6.2.7 -y &>>{LOG}
StatusCheck

#Update Listen IP

echo Start Redis Service
systemctl enable redis && systemctl restart redis &>>{LOG}
StatusCheck