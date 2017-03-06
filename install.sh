#!/bin/bash

DIR="pma"
GET="$(wget -help &> /dev/null && echo "wget" || echo "curl -O")";
T="$(date +%Y-%m-%d-%H-%M-%S)"
VER="0.0.1"

# przekazać listę np 'jeden dwa trzy' 
# funkcja zamieni sobie spacje na entery i z tego zrobi listę iterowalną przez for
function replace {
    for file in $( echo $@ | perl -pe 's/ /\n/g' )
    do 

        if [ "$(sed -nr "s/(\]\])/\1\n/p" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | uniq | wc -l)" != "0" ] ; then
            echo -e "\e[32mconfig: \e[96m${file}";

            for match in $(sed -nr "s/(\]\])/\1\n/gp" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | sort | perl -pe 's/^(?:\d+_)?(.*)$/\1/g' | uniq)
            do 
                printf "\e[32m${match} \e[33m:\e[0m";

                read VAL </dev/tty

                perl -i -p -e "s/\[\[(\d*_)?${match}\]\]/${VAL}/g" $file
            done

        else
            echo -e "\e[32mconfig: \e[96m${file}\e[0m";        
        fi

    done
}

if [ -e $DIR ]; then
    echo -e "\e[31mDirectory '$DIR' already exist\e[m"
    exit 1
fi

mkdir -p $DIR 

if [ -e $DIR ]; then     

    echo -e "\e[32mDownload pma ...\e[0m";

    $GET https://github.com/stopsopa/pma/archive/v${VER}.tar.gz?$T && mv v${VER}.tar.gz* v${VER}.tar.gz
    
    tar -zxvf v${VER}.tar.gz
    mv pma-${VER}/pma/ . && rm -rf pma-${VER} && rm v${VER}.tar.gz

    LIST="$(for i in $(find pma -maxdepth 1 -type f -name "*.php" -not -path "pma/basic_auth.php"); do     if [ $(perl -ne 'print if /\[\[.*\]\]/' $i | wc -l) != 0 ] ; then echo $i; fi     ; done | perl -pe 's/\n/ /g')"

    replace $LIST

    for file in $( echo $LIST | perl -pe 's/ /\n/g' )
    do 

        for i in $(perl -ne 'while(/\[md5\[(.+?)\]md5\]/g){print "$1\n";}' $file); do
           MD5="$(echo -n "$i" | md5sum | awk '{ print $1 }')"
           perl -i -p -e "s/\[md5\[$i\]md5\]/$MD5/g" $file
        done

    done

    echo -e "*\n"'!'".gitignore" > pma/.gitignore


    exit 0
else
    echo -e "\e[31mNie można utworzyć katalogu '$DIR' brak uprawnień\e[m";
    exit 1
fi
