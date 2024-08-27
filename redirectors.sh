#!/bin/bash

#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo  "Please run this script with root priveleges" 
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo  "$3 is...FAILED"  
        exit 1
    else
        echo "$3 is...  SUCCESS" 
    fi
}

echo "Script started executing at: $(date)"
CHECK_ROOT

dnf install mysql-server -y 
VALIDATE $? "installing my sql server"