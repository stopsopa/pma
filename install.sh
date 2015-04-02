#!/bin/bash

DIR="pma"
GET="$(wget -help &> /dev/null && echo "wget" || echo "curl -O")";
T="$(date +%Y-%m-%d-%H-%M-%S)"
FILE="master.tar.gz"

LIST="$(for i in $(find pma -maxdepth 1 -type f -name "*.php" -not -path "pma/basic_auth_lib.php"); do     if [ $(perl -ne 'print if /\[\[.*\]\]/' $i | wc -l) != 0 ] ; then echo $i; fi     ; done | perl -pe 's/\n/ /g')"

# przekazać listę np 'jeden dwa trzy' 
# funkcja zamieni sobie spacje na entery i z tego zrobi listę iterowalną przez for
function replace {
    for file in $( echo $@ | perl -pe 's/ /\n/g' )
    do 
        if [ "$(sed -nr "s/(\]\])/\1\n/p" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | uniq | wc -l)" != "0" ] ; then
            echo -e "\e[32mconfig: \e[96m${file}";

            for match in $(sed -nr "s/(\]\])/\1\n/gp" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | sort | uniq)
            do 
                printf "\e[32m${match} \e[33m:\e[0m ";

                read VAL

                perl -i -p -e "s/\[\[(\d*_)?${match}\]\]/${VAL}/g" $file
            done



        else
            echo -e "\e[32mconfig: \e[96m${file}\e[0m";        
        fi

    done
}

replace $LIST

exit 1




if [ -e $DIR ]; then
    echo -e "\e[31mJest już katalog '$DIR'\e[m"
    exit 1
fi

mkdir -p $DIR 

if [ -e $DIR ]; then     

    $GET https://github.com/stopsopa/pma/archive/master.tar.gz?$T && mv master.tar.gz* master.tar.gz
    
    tar -zxvf master.tar.gz
    mv pma-master/pma/ . && rm -rf pma-master && rm master.tar.gz

    


    exit 0


    
    for file in $(find . -type f -not -path "./.back/*")
    do 
        if [ "$(sed -nr "s/(\]\])/\1\n/p" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | uniq | wc -l)" != "0" ] ; then
            echo -e "\e[32mconfig: \e[96m${file}";

            if [ "$IMAGEEXISTS" == 0 ] ; then
                for match in $(sed -nr "s/(\]\])/\1\n/gp" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | sort | perl -pe 's/^(?:\d+_(?:im_)?)?(.*)$/\1/g' | uniq)
                do      

                    if [ $match == "container_name" ] ; then
                        echo -e "\e[32mobecne kontenery \e[33m:\e[0m";
                        docker ps -a
                    fi

                    printf "\e[32m${match} \e[33m:\e[0m ";

                    read VAL

                    perl -i -p -e "s/\[\[(\d*_(im_)?)?${match}\]\]/${VAL}/g" $file
                done
            else
                for match in $(sed -nr "s/(\]\])/\1\n/gp" $file | sed -nr "s/.*?\[\[(.*)\]\].*/\1/p" | sort | perl -pe 's/^(?:\d+_)?(.*)$/\1/g' | perl -ne 'print if not m/^im_/i' | uniq)
                do      
                    printf "\e[32m${match} \e[33m:\e[0m ";
                    read VAL

                    perl -i -p -e "s/\[\[(\d*_(im_)?)?${match}\]\]/${VAL}/g" $file
                done
            fi


        else
            echo -e "\e[32mconfig: \e[96m${file}\e[0m";        
        fi

    done




    
    

    exit 0
else
    echo -e "\e[31mNie można utworzyć katalogu '$DIR' brak uprawnień\e[m";
    exit 1
fi
