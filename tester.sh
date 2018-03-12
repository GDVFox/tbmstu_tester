#!/bin/bash

programFile="$1"
url="$2"

diffLogs=$(find ./ -name "diffLog")
if [ "$diffLogs" != "" ]; then
    rm diffLog
fi

conf="$(head -n 1 conf)"
oldURL="$(cut -d' ' -f1 <<<"$conf")"
testNum="$(cut -d' ' -f2 <<<"$conf")"
if [ "$url" != "$oldURL" ]; then
    testNum=$(./download.sh $url)
    newConf="$url $testNum"
    echo "Tests have been downloaded!"
    echo $newConf > ./conf
    echo -e "Config update:\033[1m\e[32m\t""OK! \033[0m" 
    tput sgr0
fi

g++ -std=gnu++11 $1 -o compiledProgram
for (( i=1; i <= testNum; i++ ))
do
    runtime="$( TIMEFORMAT='%lU';time ( ./compiledProgram <./tests/$i >./output ) 2>&1 1>/dev/null )"
    diff -u --ignore-all-space ./output ./answer/$i >>./diffLog

    if [ $? -eq 0 ]; then
        echo -e "Test #$i:\033[1m\e[32m\t""OK!\t\033[0m\e[36m RUNTIME:\e[0m $runtime"
        tput sgr0
    else
        echo -e "\033[1mTest #$i:\033[1m\e[31m\t""FAIL!\t\033[0m\e[36m RUNTIME:\e[0m $runtime"
        tput sgr0
    fi
done

rm ./output
rm ./compiledProgram