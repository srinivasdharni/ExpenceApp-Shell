source common.sh
component=backend

type npm &>>$log_file
if [ $? -ne 0 ]; then
	echo install NodeJS repos
	curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
	start_check
	
	echo Install NodeJS
	dnf install nodejs -y &>>$log_file
	start_check
fi
echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>$log_file
start_check

echo Add Application User
id expense &>>$log_file
if [ $? -ne 0 ]; then
useradd expense &>>$log_file
fi
start_check

echo clean app content
rm -rf /app &>>$log_file
start_check
mkdir /app 
cd /app

download_and_extract

echo Download dependencies
npm install &>>$log_file
start_check

echo start backend service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
start_check

echo Install mysql client
dnf install mysql -y &>>$log_file
start_check

echo load mysql schema
mysql -h mysql.sddevops18.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
start_check