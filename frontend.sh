set -e
yum install nginx -y &>>/tmp/frontend.log
systemctl enable nginx &>>/tmp/frontend.log
systemctl start nginx &>>/tmp/frontend.log
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend.log
cd /usr/share/nginx/html &>>/tmp/frontend.log
rm -rf * &>>/tmp/frontend.log
unzip -o /tmp/frontend.zip &>>/tmp/frontend.log
mv frontend-main/static/* . &>>/tmp/frontend.log
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend.log
systemctl restart nginx &>>/tmp/frontend.log
