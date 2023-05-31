#heading for installing
#status output
#its always important to log the output results
app_user=roboshop
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
  echo -e "\e[35m<<<<<<<<<<<< $1 on  $(date) SUCCESS >>>>>>>>>>>>\e[0m" &>>$log_file
else
  echo -e "\e[31m -----FAILURE-----\e[0m"  &>>$log_file
  echo -e "\e[35m<<<<<<<<<<<< $1 on  $(date) FAILURE >>>>>>>>>>>>\e[0m" &>>$log_file
  echo -e "\e[33m -----refer to the log file /tmp/roboshop.log for more info -----\e[0m"
  exit 1
fi
}

#--------------------------------------
#systemctl and component services  services

function_systemd_setup () {
#  function_heading "renameing the service file"
#  #converting the service file name into the normal ex: catalogue.service to catalogue.service
#  service_dir_file=$script_dir
#  service_file=$(find "$service_dir_file" -type f -name "*${component}.service*")
#  for file in $service_file; do
#    old_filename=$(basename "$service_file") &>>$log_file
#
#    #Extract the file name without the float value using the regular expression
#    new_filename=$(echo "$old_filename" | sed 's/^[0-9]*\.//') &>>$log_file
#
#    #rename the file by replacing the orignal file name with the new file name
#     if [ "$old_filename" != "$new_filename" ]; then
#        new_path="${script_dir}/$new_filename"  # Create the new path with the updated file name
#        mv "$service_file" "$new_service_file"  # Rename the file
#        echo "Renamed $service_file to $new_path" &>>$log_file
#      fi
#      done
#  function_status $?

  function_heading "coping the service file"
#  find ${script_dir} -type f -name "*${component}.service" &>>$log_file
  cp ${script_dir}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  function_status $?

  function_heading "Starting the Demon"
  systemctl daemon-reload &>>$log_file
  function_status $?

  function_heading "starting the ${component}"
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  function_status $?


}
#------------------------------------------------------
# systemctl redis service
#function_systemctl_redis () {
#  systemctl enable $service  &>>$log_file
#   function_status $?
#  systemctl restart ${service} &>>$log_file
#  function_status $?
#}


#---------------------------------------------------------------
# Systemctl service for rabbitmq
function_systemctl () {
    function_heading "starting the ${service} service"
    systemctl enable ${service}  &>>$log_file
    systemctl restart ${service} &>>$log_file
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

    function_heading "load schema"
    mysql -h mysql.dev.mohindhar.tech -uroot -p${my_sql_root_password} < /app/schema/${component}.sql &>>$log_file
    function_status $?
  fi
}

#---------------------------------------
# app pre-req
function_app_prereq () {
  function_heading "create Application user"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log    #(id roboshop to verify the user )
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

}


#----------------------------------------
# catalogue component
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


#------------------------------------------
# REDIS component
function_redis() {
  function_heading "Downloading the rpms package for redis installation "
  yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
  dnf module enable redis:remi-6.2 -y &>>$log_file
  function_status $?

  function_heading "Installing the redis"
  yum install redis -y &>>$log_file
  function_status $?

  function_heading "updating the listening port"
  # update the ip address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
  sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf &>>$log_file
  function_status $?

  function_systemctl
}


#-----------------------------------------------------
#shipping component
function_maven() {
  function_heading "installing maven"
  yum install maven -y &>>$log_file
  function_status $?

  function_app_prereq

  function_heading "Dowloading the Dependencies"
  cd /app
  mvn clean package &>>$log_file
  function_status $?
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  function_status $?

  function_schema_setup

  function_systemd_setup
}

#------------------------------------------------------------
# for mysql component
function_MySQL () {

  function_heading "Disableing the old MySQL version"
  dnf module disable mysql -y &>>$log_file
  function_status $?

  function_heading "Coping the mysql.repo file into the correct path"
  cp ${common_file_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
  function_status $?

  function_heading "Installing the mysql server"
  yum install mysql-community-server -y &>>$log_file
  function_status $?

  function_systemctl
  function_heading "Setting the password"
  mysql_secure_installation --set-root-pass $my_sql_root_password &>>$log_file
  function_status $?


}

#--------------------------------------------------------------
# rabbitmq component

function_rabbitmq () {

  function_heading "Installing the erlang package"
  curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
  yum install erlang -y &>>$log_file
  function_status $?

  function_heading " Installing the ${service} Server"
  curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>$log_file
  function_status $?

  function_heading "Install RabbitMQ "
  yum install rabbitmq-server -y &>>$log_file
  function_status $?

  function_systemctl

  function_heading "Adding the user and setting the permission"
  rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file #sudo rabbitmqctl list_users | grep roboshop (to check user in rabbitmqctl)
  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"   &>>$log_file
  function_status $?


}

#------------------------------------------------------
# payment component
function_python () {

  function_heading  "installing the python package"
  yum install python36 gcc python3-devel -y &>>"$log_file"
  function_status $?

  function_app_prereq

  function_heading " Install Python Dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  function_status $?

  function_heading "Update Passwords in System Service file"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_dir}/payment.service &>>$log_file
  function_status $?
$service
  function_systemd_setup

}

#sudo systemctl restart catalogue ; sudo  tail -f /var/log/messages