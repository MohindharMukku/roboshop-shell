echo -e "\e[35m<<<<<<<<<<<< installing the python package >>>>>>>>>>>>\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[35m<<<<<<<<<<<< adding the user >>>>>>>>>>>>\e[0m"
useradd roboshop

echo -e "\e[35m<<<<<<<<<<<< creating the directory of /app >>>>>>>>>>>>\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< downloading the payment files >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
cd /app

echo -e "\e[35m<<<<<<<<<<<< installing the pip3.6 >>>>>>>>>>>>\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[35m<<<<<<<<<<<< mving the payment.service to the correct directory >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/10.payment.service /etc/systemd/system/payment.service

echo -e "\e[35m<<<<<<<<<<<< starting the daemon and payment service >>>>>>>>>>>>\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
