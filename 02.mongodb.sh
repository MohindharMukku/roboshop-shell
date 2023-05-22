common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

function_heading "Setting up the mongo.repo file"
cp 02.mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
function_staus $?

function_heading "Changing the listing address"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf &>>$log_file
function_staus $?

function_heading "Installing the mongodb"
yum install mongodb-org -y &>>$log_file
function_staus $?

function_heading "starting the mongod"
systemctl enable mongod &>>$log_file
systemctl restart mongod &>>$log_file
function_staus $?


#edit replace 127.0.0.1 with 0.0.0.0

