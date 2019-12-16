docker-oracle-xe-10g
====================

Oracle Express Edition Universal 10g Release 2 (10.2.0.1) 32-bit on Debian 7.0 Wheezy.

(based on the work done by Kristian Du <kristian.du@gmail.com> on
[dkfi/docker-oracle-xe-10g](https://github.com/dkfi/docker-oracle-xe-10g))

Image compressed size is just 260MB for normal installation and 290MB for universal installation
Full size is just 1.36GB

### Installation
```
docker pull chameleon82/oracle-xe-10g:universal
```

Run with 22, 1521 and 8080 ports opened:
```
docker run -d -p 49160:22 -p 49161:1521 -p 49162:8080 chameleon82/oracle-xe-10g:universal
```

Connect database with following setting:
```
hostname: localhost
port: 49161
sid: xe
username: system
password: oracle
```

For example, connect to database with sqlplus:
```
sqlplus system/oracle@localhost:49161/xe
```

Password for SYS & SYSTEM
```
oracle
```

Login by SSH
```
ssh root@localhost -p 49160
password: admin
```

Login to web administrator on a browser:
```
http://localhost:49162/apex
```
