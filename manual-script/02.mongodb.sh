yum install mongodb-org -y
cp /home/centos/roboshop-shell/manual-script/mongo.repo /etc/yum.repos.d/mongo.repo
cd /etc/
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl enable mongod
systemctl start mongod
systemctl restart mongod