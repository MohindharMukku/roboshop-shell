common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

my_sql_root_password=$1

if [ -z "my_sql_root_password"]; then
  echo "Input mysql root password is missing"
  exit 1
fi

function_heading "Disableing the old MySQL version"
dnf module disable mysql -y &>>$log_file
function_status $?

function_heading "Coping the mysql.repo file into the correct path"
cp ${common_file_path}/07.mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
function_status $?

function_heading "Installing the mysql server"
yum install mysql-community-server -y &>>$log_file
function_status $?

function_heading " Enabling and starting the mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
function_status $?


function_heading "Setting the password"
mysql_secure_installation --set-root-pass $my_sql_root_password &>>$log_file
function_status $?


