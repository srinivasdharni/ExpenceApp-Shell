source common.sh
component=backend

echo install NodeJS repos
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
if [ $? -eq 0 ]; then
echo -e "\e[32mSUCCESS\e[0m"
else
echo -e "\e[31mFAILED\e[0m"
exit 1
fi

echo Install NodeJS
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
echo -e "\e[32mSUCCESS\e[0m"
else
echo -e "\e[31mFAILED\e[0m"
exit 1
fi

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
echo -e "\e[32mSUCCESS\e[0m"
else
echo -e "\e[31mFAILED\e[0m"
exit 1
fi

echo Add Application User
useradd expense &>>$log_file
if [ $? -eq 0 ]; then
echo -e "\e[32mSUCCESS\e[0m"
else
echo -e "\e[31mFAILED\e[0m"
exit 1
fi

echo clean app content
rm -rf /app &>>$log_file
echo $?
mkdir /app 
cd /app

download_and_extract

echo Download dependencies
npm install &>>$log_file
echo $?

echo start backend service
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl start backend &>>$log_file
echo $?

echo Install mysql client
dnf install mysql -y &>>$log_file
echo $?

echo load mysql schema
mysql -h mysql.sddevops18.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
echo $?