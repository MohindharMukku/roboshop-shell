common_file=$(realpath "$0")
common_file_path=$(dirname "$common_file")
source ${common_file_path}/00.common.sh

service=rabbitmq

function_heading "installing the erlang package"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
yum install erlang -y
function_status $?

function_heading " Installing the rabbitmq Server"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install rabbitmq-server -y
function_status $?

function_heading "Enabling the rabbitmq-server"
function_systemctl
function_status $?

function_heading "Adding the user and setting the permission"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
function_status $?
