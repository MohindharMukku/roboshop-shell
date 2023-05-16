
echo -e "\e[35m<<<<<<<<<<<< setting up the node js  >>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

echo -e "\e[35m<<<<<<<<<<<< adding the user 'roboshop' >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[35m<<<<<<<<<<<< creating the directory '/app' >>>>>>>>>>>>\e[0m"
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< Downloading the application code >>>>>>>>>>>>\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[35m<<<<<<<<<<<< downloading the dependencies  >>>>>>>>>>>>\e[0m"
cd /app
npm install

echo -e "\e[35m<<<<<<<<<<<< setting up the SystemD file  >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/03.catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[35m<<<<<<<<<<<< starting the daemon >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[35m<<<<<<<<<<<< starting the catalogue>>>>>>>>>>>>\e[0m"
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[35m<<<<<<<<<<<< setting up the mongo.repo >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/02.mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[35m<<<<<<<<<<<< installing the mongodd-client >>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[35m<<<<<<<<<<<< loading the schema >>>>>>>>>>>>\e[0m"
mongo --host mongodb.dev.mohindhar.tech </app/schema/catalogue.js

#update the catalogue server IP address in frontend file - /etc/nginx/default.d/01.roboshop.conf