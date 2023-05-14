echo -e “\e[35m<<<<<<<<<<<< cping the mongo.repo file  >>>>>>>>>>>>\e[0m”
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e “\e[35m<<<<<<<<<<<< chainging the listing address >>>>>>>>>>>>\e[0m”
sed -i -e ‘s |127.0.0.1|0.0.0.0|’ /etc/yum.repos.d/mongo.repo

echo -e “\e[35m<<<<<<<<<<<< installing the mongodb >>>>>>>>>>>>\e[0m”
yum install mongodb-org -y

echo -e “\e[35m<<<<<<<<<<<< starting the mongod >>>>>>>>>>>>\e[0m”
systemctl enable mongod
systemctl restart mongod

#edit replace 127.0.0.1 with 0.0.0.0

