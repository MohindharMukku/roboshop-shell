#its better to use the 'realpath' cmd with dirname cmd than pwd cmd, because the 'realpath' cmd  ensures that you get the actual path of the file, regardless of any symbolic links or relative paths used.


common_file=$(realpath "$0") #double quotes is used here to ensure filename as a single entity
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

function_heading "Installing nginx"
yum install nginx -y &>>$log_file
function_status $?

echo -e "\e[35m<<<<<<<<<<<< cping the frontend content  >>>>>>>>>>>>\e[0m"
cp 01.roboshop.conf  /etc/nginx/default.d/roboshop.conf &>>$log_file #here i'm not changing th epath, so i'm no need to give the path of config file
#cp /home/centos/roboshop-shell/01.roboshop.conf  /etc/nginx/default.d/roboshop.conf
function_status $?

function_heading "removing the nginx content"
rm -rf /usr/share/nginx/html/* &>>$log_file
function_status $?

function_heading "Dowloading the app content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
function_status $?


function_heading "Extracting the App content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
function_status $?


echo -e "\e[35m<<<<<<<<<<<< starting the nginx >>>>>>>>>>>>\e[0m"
function_heading "Starting the nginx"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
function_status $?