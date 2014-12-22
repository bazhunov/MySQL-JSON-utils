MySQL-JSON-utils
================

Some functions for JSON parsing for SQL queries
Work with the simple JSON strings (without include json)


## Install
$ mysql -u "user" -p "database" < install.sql

## Uninstall
$ mysql -u "user" -p "database" < uninstall.sql

## Descriptions

Get JSON value:
```
mysql> SELECT JSON_VALUE(payload, 'roundTripAverage') from history where link_id IS NOT NULL;
+-----------------------------------------+
| JSON_VALUE(payload, 'roundTripAverage') |
+-----------------------------------------+
| 14.561                                  |
| 14.643                                  |
| 0.155                                   |
+-----------------------------------------+
3 rows in set (0.00 sec)

```

Get JSON ARRAY Value:
```
mysql> select JSON_VALUE('{"averageCpuLoad": 1.6, "xxx": 23}', 'averageCpuLoad');
+--------------------------------------------------------------------+
| JSON_VALUE('{"averageCpuLoad": 1.6, "xxx": 23}', 'averageCpuLoad') |
+--------------------------------------------------------------------+
| 1.6                                                                |
+--------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> 
```



