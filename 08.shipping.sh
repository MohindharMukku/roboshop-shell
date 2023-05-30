common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh
mysql_root_password=$1    #RoboShop@1

if [ -z "$mysql_root_password" ]; then
  echo Input MySQL Root Password Missing
  exit
fi

component="shipping"
schema_setup=mysql
function_maven # maven = java

#echo -e "\e[35m<<<<<<<<<<<< adding the user 'roboshop' >>>>>>>>>>>>\e[0m"
#useradd roboshop
#
#echo -e "\e[35m<<<<<<<<<<<< creating the directory and installing the data of shipping >>>>>>>>>>>>\e[0m"
#rm -rf /app
#mkdir /app
#curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
#cd /app
#unzip /tmp/shipping.zip
#cd /app
#
#echo -e "\e[35m<<<<<<<<<<<< cleaning the maven >>>>>>>>>>>>\e[0m"
#mvn clean package
#mv target/shipping-1.0.jar shipping.jar
#
#echo -e "\e[35m<<<<<<<<<<<< cping the shipping.service file into the proper directory >>>>>>>>>>>>\e[0m"
#cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
#
#echo -e "\e[35m<<<<<<<<<<<< starting the daemon and shipping services >>>>>>>>>>>>\e[0m"
#systemctl daemon-reload
#systemctl enable shipping
#systemctl start shipping
#
#echo -e "\e[35m<<<<<<<<<<<< installing the mysql >>>>>>>>>>>>\e[0m"
#yum install mysql -y
#mysql -h mysql.dev.mohindhar.tech -uroot -pRoboShop@1 < /app/schema/shipping.sql
#
#echo -e "\e[35m<<<<<<<<<<<< restarting the shipping service >>>>>>>>>>>>\e[0m"
#systemctl restart shipping

