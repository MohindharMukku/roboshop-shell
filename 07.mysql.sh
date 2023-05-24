common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh
my_sql_root_password=$1

function_heading "Disableing the old MySQL version"
dnf module disable mysql -y
function_status $?

function_heading "Coping the mysql.repo file into the correct path"
cp ${common_file_path}/07.mysql.repo /etc/yum.repos.d/mysql.repo
function_status $?

function_heading "Installing the mysql server"
yum install mysql-community-server -y
function_status $?

function_heading " Enabling and starting the mysql"
systemctl enable mysqld
systemctl restart mysqld
function_status $?


function_heading "Setting the password"
mysql_secure_installation --set-root-pass 
function_status $?


