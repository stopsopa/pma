# DEPRECATED
created in 2015, but I'll leave it here

PHPMyAdmin:
====


Why?
-


Pma package to quick install from linux cli.
(The way I used to install PMA before i started using Docker)
     
Require php extension **mbstring, mysql** and **mcrypt**   

### Versions  

###### v0.0.2 - pma version 4.6.6 (up to date 2017-03-06)


     $(wget -help &> /dev/null && echo "wget -qO-" || echo "curl -s") \
     https://raw.githubusercontent.com/stopsopa/pma/master/install.sh?$(date +%Y-%m-%d-%H-%M-%S) | bash
     
---    

###### v0.0.1 - pma version 4.1.4


     $(wget -help &> /dev/null && echo "wget -qO-" || echo "curl -s") \
     https://raw.githubusercontent.com/stopsopa/pma/v0.0.1/install.sh?$(date +%Y-%m-%d-%H-%M-%S) | bash
     
---    

Sometimes on dev environment you can have no password to login to db, in this case just setup manually:


     vim pma/config.inc.php
     
     change to true:
     $cfg['Servers'][$i]['AllowNoPassword'] = true;
     and comment
     #$cfg['Servers'][$i]['password'] = '';
