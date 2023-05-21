#heading for installing
#status output
#its always important to log the output results
app_usr=roboshop
script_path=$(realpath "$0")
script_dir=$(diranme "$script_path")
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