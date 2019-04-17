# Mysql相关命令收集

## 说明

## 命令列表

### 使用mysqldump导出表结构
定义如下：
```linux
mysqldump  --compact --add-drop-table -h192.168.1.45 -uhsehome2 -p -d hsehome2 --table \
hh_comy_organ_permission \
hh_hutype_permission \
hh_permission \
hh_role_permission \
rs_admin_group_permission \
rs_admin_permission \
truc_permission \
truc_utype_permission \
hh_comy_organ_role  \
hh_comy_organ_role_perm \
hh_comy_organ_user_role \
hh_role \
hh_role_permission \
hh_role_type \
> target.sql
```

例子如下:

```linux
mysqldump  --compact --add-drop-table -h 192.168.1.45 -uhsehome2 -p -d hsehome2 --table \
hh_service_order \
hh_srefund_application \
hh_srf_source \
> service-order-table.sql
```



### 使用mysqldump导出数据库

```
mysqldump -uroot -pdbpasswd  dbname >db.sql;
```

