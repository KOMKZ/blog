# 头疼的问题记录

## composer

composer update时候报一系列找不到的错误:

```
$ composer global require "fxp/composer-asset-plugin:^1.2.0"
```

注：

不知道的时候就是找问题找到蛋疼啊。

## php

* ide中开启xdebug中始终拦截不到的问题，试一试以下德xdebug配置：

```
xdebug.remote_enable=1
xdebug.remote_host=0.0.0.0
xdebug.remote_connect_back=0    # Not safe for production servers
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_autostart=true
```



* php-excel在导出数据其中必须插入图片的话，需要注意如果图片过大一般来说都会导致内存溢出，解决的方法是对图片生成缩略图。

### 独坐南山头，玉龙静水中

偶然发现fwirte写入文件之后，再使用require将文件的数据导入，发现文件并不是最新的，只有再执行一次require的时候才获取到罪行数据。

解决方法：

```
https://stackoverflow.com/questions/31404576/php-file-is-not-refreshed-after-fwrite-and-fclose
```

即考虑在读取和写入前：

```
ini_set('opcache.enable', '0');
```

## Ubuntu

快捷键使用

| cmd            | description                              |
| -------------- | ---------------------------------------- |
| alt + prt sc   | take a screenshotcut of the current window |
| shift + prt sc | take a screenshotcut of a selected rectangle on a screen. |
|                |                                          |

