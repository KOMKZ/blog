# mysql相关命令收集

## 说明

## 命令列表

### 使用mysqldump命令导出指定表
定义如下：
```linux
mysqldump  --compact --add-drop-table -h HOST_ADDRESS -uUSERNAME -p -d DATABASE_NAME --table \
TABLE_NAME_1 \
TABLE_NAME_2 \
> OUTPUT_FILE_NAME
```

例子如下:

```linux
mysqldump  --compact --add-drop-table -h 192.168.1.45 -uhsehome2 -p -d hsehome2 --table \
hh_service_order \
hh_srefund_application \
hh_srf_source \
> service-order-table.sql
```
