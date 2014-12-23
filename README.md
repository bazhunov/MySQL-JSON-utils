MySQL-JSON-utils
================

Some functions for JSON parsing. 
Work with the simple JSON strings (without include json)


## Install
$ mysql -u "user" -p "database" < install.sql

## Uninstall
$ mysql -u "user" -p "database" < uninstall.sql

## Descriptions

Get JSON value:
```

mysql> SELECT  payload from history where link_id IS NOT NULL LIMIT 3;
...
{"packetsTransmitted":4,"packetsReceived":4,"roundTripMinimal":14.356,"roundTripAverage":14.561,"roundTripMaximum":14.722}
{"packetsTransmitted":4,"packetsReceived":4,"roundTripMinimal":14.356,"roundTripAverage":14.643,"roundTripMaximum":14.722} 
{"packetsTransmitted":4,"packetsReceived":4,"roundTripMinimal":14.356,"roundTripAverage":0.155,"roundTripMaximum":14.722} 
3 rows in set (0.00 sec)

mysql> SELECT JSON_VALUE(payload, 'roundTripAverage') from history where link_id IS NOT NULL LIMIT 3;
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
mysql> select JSON_ARRAY_VALUE('{"averageCpuLoad": [1.6,1.23,1.4,1.77]}', 'averageCpuLoad', 3);
+----------------------------------------------------------------------------------+
| JSON_ARRAY_VALUE('{"averageCpuLoad": [1.6,1.23,1.4,1.77]}', 'averageCpuLoad', 3) |
+----------------------------------------------------------------------------------+
| 1.4                                                                              |
+----------------------------------------------------------------------------------+
1 row in set (0.00 sec)

mysql> select JSON_ARRAY_VALUE('[1.6,1.23,1.4,1.77]',NULL, 4);
+-------------------------------------------------+
| JSON_ARRAY_VALUE('[1.6,1.23,1.4,1.77]',NULL, 4) |
+-------------------------------------------------+
| 1.77                                            |
+-------------------------------------------------+
1 row in set (0.00 sec)
```



