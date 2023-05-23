#heading for installing
#status output
#its always important to log the output results
app_usr=roboshop
script_path=$(realpath "$0")
script_dir=$(dirname "$script_path")
log_file=/tmp/roboshop.log
#------------------------------------
#head function

function_heading () {
 echo -e "\e[35m<<<<<<<<<<<< $1 >>>>>>>>>>>>\e[0m"
 echo -e "\e[35m<<<<<<<<<<<< $1 on  $(date) >>>>>>>>>>>>\e[0m" &>>$log_file
}

#-------------------------------------
#status check

function_status () {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m -----SUCCESS-----\e[0m"
else
  echo -e "\e[31m -----FAILURE-----\e[0m"
  echo -e "\e[33m -----refer to the log file /tmp/roboshop.log for more info -----\e[0m"
  exit 1
fi
}

#--------------------------------------
#systemctl and component services  services

function_systemd_setup () {
  function_heading "coping the service file"
  cp ${component}.service /etc/systemd/system/${component}.service &>>$log_file
  function_status $?

  function_heading "Starting the Demon"
  systemctl daemon-reload &>>$log_file
  function_status $?

  echo -e "\e[35m<<<<<<<<<<<< starting the catalogue>>>>>>>>>>>>\e[0m"
  function_heading "starting the $component"
  systemctl enable $component &>>$log_file
  systemctl restart $component &>>$log_file
  function_status $?

}

#-------------------------------------------
# schema setup for mongodb and my_sql
function_schema_setup () {
  if [ "$schema_setup" == "mongo" ]; then
  function_heading "Configure the mongodb package management system"  #MongoDB Community Edition using the yum package manager
  cp ${script_dir}/02.mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
   function_status $?

  function_heading "installing the mongodb"
  yum install -y mongodb-org-shell &>>$log_file
   function_status $?

  function_heading "load schema"
  mongo --host mongodb.dev.mohindhar.tech </app/schema/${component}.js &>>$log_file
  function_status $?
  fi


  if [ "$schema_setup" == "my_sql" ]; then
    function_heading " installing the my_sql_client"
    yum install mysql -y &>>$log_file
    function_status $?

    function_heading " load schema "
    mysql -h mysql-dev.rdevopsb72.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
    func_stat_check $?
  fi
}

#---------------------------------------
# app pre-req
function_app_prereq () {
  function_heading "create Application user"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
  fi
  function_status $?

  function_heading "Create Application Directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  function_status $?

  function_heading "Download Application Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  function_status $?

  function_heading "Extract Application Content"
  cd /app &>>$log_file
  unzip /tmp/${component}.zip &>>$log_file
  function_status $?

  function_heading "Downloading the Dependencies"
  npm install &>>$log_file
  function_status $?
}


#----------------------------------------
#installation of node js
function_nodejs () {
  function_heading "configuring NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  function_status $?

  function_heading "install NodeJS"
  yum install nodejs -y &>>$log_file
  function_status $?

  function_app_prereq #function in a function

  function_heading "Install NodeJS Dependencies "
  npm install &>>$log_file
  function_status $?

  function_schema_setup    #function in a function
  function_systemd_setup   #function in a function

}
