# Manticore Search Docker Image

An image for Manticore search based on Debian 9

# About Manticore 

Manticore Search is an open source full-text search server. The image use Alpine as operating system.

The searchd daemon runs in nodetach mode. Default configuration includes includes a simple Real-Time index and listen on the default ports ( `9306`  for SphinxQL and `9312` for SphinxAPI).

The image comes with MySQL  and PostgreSQL client libraries for indexing data from these databases as well as expat library for indexing data from XML files.


# How to run this image

## Quick usage

```
docker run --name manticore -p 9306:9306 -d stephenafamo/manticore
```
  
To take a look at the data:
  
```
  $ docker exec -it manticore mysql -h127.0.0.1 -P9306
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 1
Server version: 2.4.1 3b31a97@171017 id64-release 

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> SHOW TABLES;
+--------+------+
| Index  | Type |
+--------+------+
| testrt | rt   |
+--------+------+
1 row in set (0,00 sec)

mysql> INSERT INTO testrt(id,title,content,gid) VALUES(1,'Hello','World',10);
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM testrt;
+------+------+
| id   | gid  |
+------+------+
|    1 |   10 |
+------+------+
1 row in set (0,00 sec)
```

To shutdown the daemon:

```
docker stop manticore
```

## Mounting points

The configuration folder inside the image is the usual `/etc/sphinxseach`. 
Index files are located at `/var/lib/manticore/data` and logs at `/var/lib/manticore/log`.
For persistence, mount these points to your local folders.

```
docker run --name manticore -v ~/manticore/etc/:/etc/sphinxsearch/ -v ~/manticore/data/:/var/lib/manticore/data -v ~/manticore/logs/:/var/lib/manticore/log -p 9306:9306 -d stephenafamo/manticore
```
    
In `~/manticore/` you need to create the `etc/`,`data/` and `logs/` folders, as well as add a valid  [sphinx.conf](https://github.com/manticoresoftware/docker/blob/master/sphinx.conf)   in `~/manticore/etc/`.  

## Rotating indexes

```
docker exec -it manticore indexer --all --rotate
```

## Default configuration

```
index testrt
{
    type            = rt
    rt_mem_limit    = 128M
    path            = /var/lib/manticore/data/testrt
    rt_field        = title
    rt_field        = content
    rt_attr_uint    = gid
}

searchd
{
    listen          = 9312
    listen          = 9306:mysql41
    log             = /var/lib/manticore/log/searchd.log
    query_log       = /var/lib/manticore/log/query.log
    read_timeout    = 5
    max_children    = 30
    pid_file        = /var/run/searchd.pid
    seamless_rotate = 1
    preopen_indexes = 1
    unlink_old      = 1
    workers         = threads # 
    binlog_path     = /var/lib/manticore/data
}
```


# Issues

For reporting issues, please use the [issue tracker](https://github.com/stephenafamo/manticore/issues).

