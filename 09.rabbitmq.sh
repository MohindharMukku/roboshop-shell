
echo -e "\e[35m<<<<<<<<<<<< installing the erlang package >>>>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
yum install erlang -y

echo -e "\e[35m<<<<<<<<<<<< installing the rabbitmq server >>>>>>>>>>>>\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
yum install rabbitmq-server -y

echo -e "\e[35m<<<<<<<<<<<< enabling the rabbitmq-server >>>>>>>>>>>>\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[35m<<<<<<<<<<<< adding the user and setting the permission >>>>>>>>>>>>\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
