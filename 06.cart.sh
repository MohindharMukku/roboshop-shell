echo -e "\e[35m<<<<<<<<<<<< changing the hostname  >>>>>>>>>>>>\e[0m"
sudo bash set-hostname 06-cart

echo -e "\e[35m<<<<<<<<<<<< start the user service >>>>>>>>>>>>\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[35m<<<<<<<<<<<< install node nodejs >>>>>>>>>>>>\e[0m"
yum install nodejs -y

echo -e "\e[35m<<<<<<<<<<<< adding the user 'roboshop' >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[35m<<<<<<<<<<<< create the /app directory >>>>>>>>>>>>\e[0m"
rm -rf /app #this cmd removes the /app dir if we are running the shell script for second time
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< installing the cart files >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install

echo -e "\e[35m<<<<<<<<<<<< cping the cart.service file into correct directory >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/06.06.cart.service /etc/systemd/system/cart.service

echo -e "\e[35m<<<<<<<<<<<< loading & starting the cart services  >>>>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
