#!/bin/bash

#creating BackEnd server

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

CHECK_ROOT(){

    if [ $USERID -ne 0 ]
        then
            echo -e "$R Please run this script with root user $N" | tee -a $LOG_FILE
            exit 1
        else 
            echo -e "$Y This Script excuting with Root user $N" | tee -a $LOG_FILE
    fi
}

VALIDATE(){

    if [ $1 -ne 0 ]
        then
            echo -e "$2...is $R FAILED" | tee -a $LOG_FILE
            exit 1
        else
            echo -e "$2....is $G SUCCESS" | tee -a $LOG_FILE
    fi
}

echo  "Scripit strated executing at : $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Nodejs Disabled"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabled Nodejs"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installed Nodejs"

id expense &>>$LOG_FILE
if [ $? -ne 0 ]
    then
        echo "expense user already exits... creating"
        useradd expense
        VALIDATE $? "creating expense user"
    else
fi

mkdir /app 
VALIDATE $? "creating /app"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "downloading backend application"

cd /app
rm -rf /app/* # removing the existing code

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Extracting Backend application"

npm install &>>$LOG_FILE
cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service

#Load thr data before running backend server

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installing Mysql client"

mysql -h mysql.naveenreddy.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "Schema Loading"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Daemon reload"

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "Enabled backend"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "Restarted Backend"

