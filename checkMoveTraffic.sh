#!/bin/bash
input="./listdbs.txt"
count=0
pass=$1
while IFS= read -r line
do
	knife node list | grep "$line" | grep mysql | grep -v proxy > ./listServers
	
	while IFIN= read -r lineservers
	do
		echo `mysql -h $lineservers -p$pass -u dbschema -sN -e "select * from mysql.user where user='movetrafficuser'"` $lineservers >> ./newUserInfo.csv
	done < ./listServers
        if [ count -eq 0 ]; then
		break;
	fi
done < "$input"
