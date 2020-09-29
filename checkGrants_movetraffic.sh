#!/bin/bash
input="./listdbs.txt"
good_grant="GRANT ALL PRIVILEGES ON *.* TO 'movetrafficuser'@'10.%'"
pass=$1
while IFS= read -r line
do
	knife node list | grep "$line" | grep mysql | grep -v proxy > ./listServers
	while IFIN= read -r lineservers
	do
		grants_for_user=`mysql -h $lineservers -p$pass -u dbschema -sN -e "SHOW GRANTS FOR 'movetrafficuser'@'10.%'"`
		if [ "$grants_for_user" = "$good_grant" ]; then
			echo $lineservers 'is OK' >> ./goodResults.txt
		elif [ -z "$grants_for_user" ]; then
			echo $lineservers "is not OK, couldn't connect to host" >> ./badResults.txt
		else
			echo $lineservers "is not OK, grant is " "$grants_for_user" >> ./badResults.txt		
		fi		
	done < ./listServers
done < "$input"
