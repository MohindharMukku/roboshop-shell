echo -e "\e[35m<<<<<<<<<<<< changing the hostname  >>>>>>>>>>>>\e[0m"
sudo bash set-hostname 05-user


echo -e "\e[35m<<<<<<<<<<<< downloading  and installing node js >>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

echo -e "\e[35m<<<<<<<<<<<< adding the user 'roboshop' >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[35m<<<<<<<<<<<< directory /app >>>>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< downloading the user files  >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app

echo -e "\e[35m<<<<<<<<<<<< installing the npm service >>>>>>>>>>>>\e[0m"
npm install

echo -e "\e[35m<<<<<<<<<<<< cping the user.service file into the right directory >>>>>>>>>>>>\e[0m"
cp cp /home/centos/roboshop-shell/05.user.service /etc/systemd/system/user.service

echo -e "\e[35m<<<<<<<<<<<< start the user service >>>>>>>>>>>>\e[0m"
systemctl enable user
systemctl start user

echo -e "\e[35m<<<<<<<<<<<< cping the mongo.repo file into right directory >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/02.mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[35m<<<<<<<<<<<< install mongodb service >>>>>>>>>>>>\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[35m<<<<<<<<<<<< load the user  schema >>>>>>>>>>>>\e[0m"
mongo --host mongodb.dev.mohindhar.tech </app/schema/user.js