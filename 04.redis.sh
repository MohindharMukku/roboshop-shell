
echo -e "\e[35m<<<<<<<<<<<< installing the rpms >>>>>>>>>>>>\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y

echo -e "\e[35m<<<<<<<<<<<< installing the redis >>>>>>>>>>>>\e[0m"
yum install redis -y

echo -e "\e[35m<<<<<<<<<<<< updating the listening port  >>>>>>>>>>>>\e[0m"
# update the ip address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[35m<<<<<<<<<<<< starting the redis service >>>>>>>>>>>>\e[0m"
systemctl enable redis
systemctl restart redis