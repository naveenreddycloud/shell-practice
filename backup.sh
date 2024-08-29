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

    echo -e " $R Usage:: $N to excute this scripit $0 user must pass arguments like <SOURCEFILE> <DESTINATIONFILE> <DAYS(Optional)>"

}

if [ $# -lt 2 ]
    then 
        USAGE 
        exit 1
fi

    