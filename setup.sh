#!/bin/sh

echo "Waiting for mysql-master..."

until mysqladmin ping -h mysql-master -urepl -prepl123 --silent
do
    sleep 2
done

echo "mysql-master is ready."

echo "Waiting for mysql-slave..."

until mysqladmin ping -h mysql-slave -urepl -prepl123 --silent
do
    sleep 2
done

echo "mysql-slave is ready."

echo "Configuring slave..."

mysql -h mysql-slave -uroot -proot <<'EOF'
STOP REPLICA;
RESET REPLICA ALL;

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='mysql-master',
    SOURCE_PORT=3306,
    SOURCE_USER='repl',
    SOURCE_PASSWORD='repl123',
    SOURCE_AUTO_POSITION=1;

START REPLICA;
EOF

echo "Replication slave configured."

echo "Configuring master..."

mysql -h mysql-master -uroot -proot <<'EOF'
STOP REPLICA;
RESET REPLICA ALL;

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='mysql-slave',
    SOURCE_PORT=3306,
    SOURCE_USER='repl',
    SOURCE_PASSWORD='repl123',
    SOURCE_AUTO_POSITION=1;

START REPLICA;
EOF

echo "Replication master configured."