# 头疼的问题记录

## composer

composer update时候报一系列找不到的错误:

```
$ composer global require "fxp/composer-asset-plugin:^1.2.0"
```

注：

不知道的时候就是找问题找到蛋疼啊。

## php

ide中开启xdebug中始终拦截不到的问题，试一试以下德xdebug配置：

```
xdebug.remote_enable=1
xdebug.remote_host=0.0.0.0
xdebug.remote_connect_back=0    # Not safe for production servers
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_autostart=true
```

## Ubuntu

快捷键使用

| cmd            | description                              |
| -------------- | ---------------------------------------- |
| alt + prt sc   | take a screenshotcut of the current window |
| shift + prt sc | take a screenshotcut of a selected rectangle on a screen. |
|                |                                          |

