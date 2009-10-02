#!/bin/bash

if [ "$UID" -ne 0 ]
then
        echo -e "\nYou must be root to run this test.\nExit.\n"
        exit
fi

echo -e "\n\n*** WARNING!!! All Bacula, Webacula databases and files will be erased!!!\n"
echo -e "\n*** Press Enter to continue ...\n\n"
# read

/usr/bin/psql -l
if test $? -ne 0; then
  echo "Can't connect to postgresql."
  /sbin/service postgresql start
   sleep 7
fi

/usr/bin/mysqlshow mysql
if test $? -ne 0; then
	echo "Can't connect to mysqld."
	/sbin/service mysqld start
   sleep 7
fi

cd /etc/bacula
./bacula stop
sleep 3

echo -e "\n\n"

rm -r -f /tmp/webacula/sqlite/*
rm -r -f /tmp/webacula/*
rmdir /tmp/webacula

/usr/bin/mysql -f <<END-OF-DATA
	DROP DATABASE bacula;
	DROP DATABASE webacula;
END-OF-DATA

if test $? -eq 0 ; then
	echo "Drop MySQL databases succeeded."
else
	echo "Drop MySQL databases failed."
fi


if /usr/bin/dropdb bacula
then
   echo "Drop PGSQL bacula database succeeded."
else
   echo "Drop PGSQL bacula database failed."
fi

if /usr/bin/dropdb webacula
then
   echo "Drop PGSQL webacula database succeeded."
else
   echo "Drop PGSQL webacula database failed."
fi

/usr/bin/psql -f - -d template1 <<END-OF-DATA
	DROP USER wbuser;
END-OF-DATA

rm -f /tmp/webacula_restore_*.tmp

