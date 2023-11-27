#! /bin ?bash
sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo you install maven -y

if[-d"addressbook"]
then
echo"repo is cloned"
cd /home/ec2-user/adressbook
git pull origin master
else

git clone https://github.com/naiduparesh/addressbook.git
fi
cd /home/ec2-user/addressbook
mvn package