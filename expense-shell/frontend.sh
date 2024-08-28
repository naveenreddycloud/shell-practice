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

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing Nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Nginx started"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default website"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend content"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Extracting frontend content"

cp /home/ec2-user/shell-practice/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE
VALIDATE $? "copied expense config"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarted Nginx Server"






