common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/common.sh
rabbitmq_appuser_password=$1

component=dispatch

function_heading "installing the golang"
yum install golang -y &>>$log_file
function_status $?

function_app_prereq

function_heading "Update Passwords in System Service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_dir}/dispatch.service &>>$log_file
  function_status $?

function_heading "Downloading the dependencies and building the software"
cd /app &>>"$log_file"
go mod init dispatch &>>"$log_file"
go get &>>$log_file
go build &>>$log_file
function_status $?

function_systemd_setup

#echo -e "\e[35m<<<<<<<<<<<< creating the user 'roboshop' >>>>>>>>>>>>\e[0m"
#useradd roboshop
#rm -rf /app
#mkdir /app
#
#echo -e "\e[35m<<<<<<<<<<<< setting up all the dispatch files  >>>>>>>>>>>>\e[0m"
#curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
#cd /app
#unzip /tmp/dispatch.zip
#
#echo -e "\e[35m<<<<<<<<<<<< downloading the dependencies and building the software >>>>>>>>>>>>\e[0m"
#cd /app
#go mod init dispatch
#go get
#go build
#
#echo -e "\e[35m<<<<<<<<<<<< mving the systemd file into correct directory >>>>>>>>>>>>\e[0m"
#cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service
#
#echo -e "\e[35m<<<<<<<<<<<< loading the daemon file >>>>>>>>>>>>\e[0m"
#systemctl daemon-reload
#
#echo -e "\e[35m<<<<<<<<<<<< strating the services  >>>>>>>>>>>>\e[0m"
#systemctl enable dispatch
#systemctl restart dispatch