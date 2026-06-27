## How to run
```bash
docker compose up -d
```

Coba akses mysql dengan port 3307 dan 3308 dengan mysql client.

atau dengan 

### Master
```bash
docker exec -it mysql-master mysql -uroot -proot
```

### Slave
```bash
docker exec -it mysql-slave mysql -uroot -proot
```

## How to stop
```bash
docker compose down
```


## Mysql Slave Container
Run command below to start connection to master and start replica
```sql
CHANGE REPLICATION SOURCE TO
SOURCE_HOST='mysql-master',
SOURCE_PORT=3306,
SOURCE_USER='repl',
SOURCE_PASSWORD='repl123',
SOURCE_AUTO_POSITION=1;

START REPLICA;
```