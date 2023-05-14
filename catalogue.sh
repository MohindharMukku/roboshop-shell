echo -e "\e[35m<<<<<<<<<<<< Downloading and Installing the node js  >>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

echo -e "\e[35m<<<<<<<<<<<< adding the user 'roboshop' >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[35m<<<<<<<<<<<< creating the directory '/app' >>>>>>>>>>>>\e[0m"
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< Downloading the catalogue files >>>>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app

echo -e "\e[35m<<<<<<<<<<<< installing the npm  >>>>>>>>>>>>\e[0m"
npm install

echo -e "\e[35m<<<<<<<<<<<< cping the catalogue.service file to correct directory >>>>>>>>>>>>\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[35m<<<<<<<<<<<< starting the daemon >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[35m<<<<<<<<<<<< starting the catalogue>>>>>>>>>>>>\e[0m"
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[35m<<<<<<<<<<<< cping the mongo.repo file into correct directory >>>>>>>>>>>>\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[35m<<<<<<<<<<<< installing the mongodb >>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[35m<<<<<<<<<<<< loading the schema >>>>>>>>>>>>\e[0m"
mongo --host mongodb.mohindhar.tech </app/schema/catalogue.js

#update the catalogue server IP address in frontend file - /etc/nginx/default.d/roboshop.conf