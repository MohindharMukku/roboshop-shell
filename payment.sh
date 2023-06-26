common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh
rabbitmq_appuser_password=$1    #roboshop123

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Roboshop Appuser Password Missing
  exit 1
fi

component=payment
function_python

#echo -e "\e[35m<<<<<<<<<<<< adding the user >>>>>>>>>>>>\e[0m"
#useradd roboshop
#
#echo -e "\e[35m<<<<<<<<<<<< creating the directory of /app >>>>>>>>>>>>\e[0m"
#rm -rf /app
#mkdir /app
#
#echo -e "\e[35m<<<<<<<<<<<< downloading the payment files >>>>>>>>>>>>\e[0m"
#curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
#cd /app
#unzip /tmp/payment.zip
#cd /app
#
#echo -e "\e[35m<<<<<<<<<<<< mving the payment.service to the correct directory >>>>>>>>>>>>\e[0m"
#cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
#
#echo -e "\e[35m<<<<<<<<<<<< starting the daemon and payment service >>>>>>>>>>>>\e[0m"
#systemctl daemon-reload
#systemctl enable payment
#systemctl restart payment
