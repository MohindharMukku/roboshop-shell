
echo -e "\e[35m<<<<<<<<<<<< Installing nginx >>>>>>>>>>>>\e[0m"
yum install nginx -y

echo -e "\e[35m<<<<<<<<<<<< removing the nginx content >>>>>>>>>>>>\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35m<<<<<<<<<<<< dowloading the artifacts >>>>>>>>>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35m<<<<<<<<<<<< changind the dir  >>>>>>>>>>>>\e[0m"
cd /usr/share/nginx/html

echo -e "\e[35m<<<<<<<<<<<< unzipping the frontend content >>>>>>>>>>>>\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m<<<<<<<<<<<< cping the frontend content  >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/01.roboshop.conf  /etc/nginx/default.d/roboshop.conf

echo -e "\e[35m<<<<<<<<<<<< starting the nginx >>>>>>>>>>>>\e[0m"
systemctl enable nginx
systemctl restart nginx