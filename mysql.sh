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

echo "show databases;" | mysql -uroot -p$MYSQL_PASSWD &>>{LOG}
if [ $? -ne 0 ]; then
  echo Changing the default password
  DEFAULT_PASSWD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWD}
fi

echo "show plugins;" | mysql -uroot -p$MYSQL_PASSWD 2>&1 | grep validate_password &>>{LOG}
if [ $? -eq 0 ]; then
  echo Removing the password validate plugin
  echo uninstall plugin validate_password | mysql -uroot -p$MYSQL_PASSWD &>>{LOG}
  StatusCheck
fi

#> uninstall plugin validate_password;
DOWNLOAD

echo "Extract and Load Schema "
cd /tmp &>>{LOG} && unzip -o mysql.zip  &>>{LOG} && cd mysql-main &>>{LOG} && mysql -u root -pRoboShop@1 <shipping.sql &>>{LOG}
StatusCheck