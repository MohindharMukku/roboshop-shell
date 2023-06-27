common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/common.sh

service=rabbitmq-server
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Roboshop Appuser Password Missing
  exit 1
fi

function_rabbitmq

#function_heading "installing the erlang package"
#curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
#yum install erlang -y
#function_status $?
#
#function_heading " Installing the rabbitmq Server"
#curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
#yum install rabbitmq-server -y
#function_status $?
#
#function_heading "Enabling the rabbitmq-server"
#function_systemctl
#function_status $?
#
#function_heading "Adding the user and setting the permission"
#rabbitmqctl add_user roboshop roboshop123
#rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
#function_status $?
