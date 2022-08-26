source common.sh
COMPONENT=mysql

if [ -z "$MYSQL_PASSWD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWD is missing\e[0m"
  exit 1
fi

echo Setup Yum Repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>{LOG}
StatusCheck

echo Install MYSQL
yum install mysql-community-server -y &>>{LOG}
StatusCheck

echo Start Mysql Service
systemctl enable mysqld &>>{LOG} && systemctl start mysqld &>>{LOG}
StatusCheck

echo "show plugins;" | mysql -uroot -p$MYSQL_PASSWD | grep validate_password &>>{LOG}
if [ $? -ne 0 ] ; then
  echo Remove Password Validate Plugin
 echo "uninstall plugin validate_password;" | mysql -uroot -P$MYSQL_PASSWD
 fi

exit

#> uninstall plugin validate_password;
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
cd /tmp
unzip mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql
