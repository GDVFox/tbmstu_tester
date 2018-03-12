#!/bin/bash

rm ./answer/*
rm ./tests/*

for (( counter = 1 ; ; counter++ ))
do
    wget -r --no-parent -nd -q -P ./tests $1/$counter
    wget -r --no-parent -nd -q -P ./answer $1/$counter.a
    if [ $? -ne 0 ]
    then
        echo "$(( --counter ))"
        break
    fi

    mv ./answer/$counter.a ./answer/$counter
done