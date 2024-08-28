#!/bin/bash

#creating DataBase server

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
            echo -e "$R Please run this scripit with root user $N" | tee -a $LOG_FILE
            exit 1
        else 
            echo "$Y This Scripit excuting with Root user $N" | tee -a $LOG_FILE
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

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing MYSQL server"

systemctl enable mysqld
VALIDATE $? "Enabled Mysqld Server" &>>$LOG_FILE

systemctl start mysqld
VALIDATE $? "Started Mysqld server" &>>$LOG_FILE

mysql -h mysql.naveenreddy.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE

if [ $? -ne 0 ]
    then 
        echo "MySql root password not setup..setting now" &>>$LOG_FILE
        mysql_secure_installation --set-root-pass ExpenseApp@1
        VALIDATE $? "Setting up root Password"
    else
        echo -e "$R MySql root password is already created ...$Y Now Skipping $N" | tee -a $LOG_FILE
fi




