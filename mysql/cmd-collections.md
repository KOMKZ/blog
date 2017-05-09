# Mysql Cmd Collections

## Preface

## Content

### Export structure of specifed tables with command mysqldump

```mysql
mysqldump  --compact --add-drop-table -h HOST_ADDRESS -uUSERNAME -p -d DATABASE_NAME --table \
TABLE_NAME_1 \
TABLE_NAME_2 \
> OUTPUT_FILE_NAME
```

example:

```msyql
mysqldump  --compact --add-drop-table -h 192.168.1.45 -uhsehome2 -p -d hsehome2 --table \
hh_service_order \
hh_srefund_application \
hh_srf_source \
> service-order-table.sql 
```

