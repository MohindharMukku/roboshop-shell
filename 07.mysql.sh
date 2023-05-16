echo -e "\e[35m<<<<<<<<<<<< changing the hostname  >>>>>>>>>>>>\e[0m"
sudo bash set-hostname 07-mysql
echo -e "\e[35m<<<<<<<<<<<< starting the mysql service >>>>>>>>>>>>\e[0m"
dnf module disable mysql -y

echo -e "\e[35m<<<<<<<<<<<< cping the mysql.repo file into the correct directory >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/07.mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[35m<<<<<<<<<<<< installing the mysql server >>>>>>>>>>>>\e[0m"
yum install mysql-community-server -y

echo -e "\e[35m<<<<<<<<<<<< enabling and starting the mysql >>>>>>>>>>>>\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[35m<<<<<<<<<<<< setting the usr and passwrd >>>>>>>>>>>>\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1
