#!/bin/sh
set -ex

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
fi

if [ -d "$MYSQL_DATA_DIRECTORY" ]; then
	echo 'MySQL data directory exists'
else
	echo 'MySQL data directory does not exist'

  echo 'Initializing database'
	mkdir -p "$MYSQL_DATA_DIRECTORY"
	mysql_install_db --user=root --datadir="$MYSQL_DATA_DIRECTORY" --rpm
	echo 'Database initialized'

	tfile=$(mktemp)
  if [ ! -f "$tfile" ]; then
      return 1
  fi

  cat <<-EOF > "$tfile"
		USE mysql;
		FLUSH PRIVILEGES;
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
		UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
	EOF

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < "$tfile"
  rm -f "$tfile"

  #mkdir /openmrs-dump-to-import  

fi

mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS export_db"
mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE export_db CHARACTER SET utf8 COLLATE utf8_general_ci"
mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" export_db < /startup-scripts/export_db.sql

file_to_import_found=false
for file in $(ls -t /openmrs-dump-to-import/*.sql)
do
  file_to_import_found=true
  echo "Importing openmrs database from file $file"
  mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE IF EXISTS openmrs"
  mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE openmrs CHARACTER SET utf8 COLLATE utf8_general_ci"
  mysql_embedded -uroot -p"$MYSQL_ROOT_PASSWORD" openmrs < $file
  break
done

if [ $file_to_import_found = false ]
then
	echo "Ficheiro para importar não encontrado"
	return 1
fi


echo 'Starting server'
exec /usr/bin/mysqld --user=root --console
