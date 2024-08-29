#!/bin/bash

SOURCE_DIRECTORY=${1}
DESTINATION_DIRECTORY=${2}
DAYS=${3:-14}
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USAGE(){

    echo -e " $R Usage:: $N to excute this scripit $G ${0} $N user must pass arguments like <SOURCEFILE> <DESTINATIONFILE> <DAYS(Optional)>"

}

if [ $# -lt 2 ]
    then 
        USAGE 
        exit 1
fi

if [ -d $SOURCE_DIRECTORY ]
    then
        echo "$SOURCE_DIRECTORY is presents ..."
    else 
        echo "$SOURCE_DIRECTORY is not presents .."
        
fi


if [ -d $DESTINATION_DIRECTORY ]
    then
        echo "$DESTINATION_DIRECTORY is presents ..."
    else 
        echo "$DESTINATION_DIRECTORY is not presents .."
        
fi


FILES=$(find ${SOURCE_DIRECTORY} -name "*.log" -mtime $DAYS)

echo "files:$FILES"


then
    echo "files are found"
    ZIP_FILE="$DESTINATION_DIRECTORY/app-logs-$TIMESTAMP.zip"
    find ${SOURCE_DIRECTORY} -name "*.log" -mtime $DAYS | zip "$ZIP_FILE" -@

fi




    