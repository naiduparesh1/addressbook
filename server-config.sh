#! /bin /bash
#sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install docker -y
sudo systemctl start docker
#sudo yum install maven -y

if [ -d "addressbook" ]
then
echo "repo is cloned"
cd /home/ec2-user/addressbook
git pull origin master
else
git clone https://github.com/naiduparesh/addressbook.git
cd /home/ec2-user/addressbook
git checkout master
fi
#mvn package
sudo docker build -t $1:$2 /home/ec2-user/addressbook