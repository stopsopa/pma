#!/bin/bash

DIR="pma"
GET="$(wget -help &> /dev/null && echo "wget" || echo "curl -O")";
T="$(date +%Y-%m-%d-%H-%M-%S)"

if [ -e $DIR ]; then
    echo -e "\e[31mJest już katalog '$DIR'\e[m"
    exit 1
fi

mkdir -p $DIR 

if [ -e $DIR ]; then     

    $GET https://github.com/stopsopa/pma/archive/master.tar.gz?$T && mv master.tar.gz* master.tar.gz
    
    tar -zxvf master.tar.gz
    mv pma-master/pma/ . && rm -rf pma-master
    
    

    exit 0
else
    echo -e "\e[31mNie można utworzyć katalogu '$DIR' brak uprawnień\e[m";
    exit 1
fi
