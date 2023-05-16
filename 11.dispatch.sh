echo -e "\e[35m<<<<<<<<<<<< changing the hostname  >>>>>>>>>>>>\e[0m"
sudo bash set-hostname 11.dispatch

echo -e "\e[35m<<<<<<<<<<<< installing the golang >>>>>>>>>>>>\e[0m"
yum install golang -y

echo -e "\e[35m<<<<<<<<<<<< creating the user 'roboshop' >>>>>>>>>>>>\e[0m"
useradd roboshop
rm -rf /app
mkdir /app

echo -e "\e[35m<<<<<<<<<<<< setting up all the dispatch files  >>>>>>>>>>>>\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[35m<<<<<<<<<<<< downloading the dependencies and building the software >>>>>>>>>>>>\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[35m<<<<<<<<<<<< mving the systemd file into correct directory >>>>>>>>>>>>\e[0m"
cp /home/centos/roboshop-shell/11.dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[35m<<<<<<<<<<<< loading the daemon file >>>>>>>>>>>>\e[0m"
systemctl daemon-reload

echo -e "\e[35m<<<<<<<<<<<< strating the services  >>>>>>>>>>>>\e[0m"
systemctl enable dispatch
systemctl restart dispatch