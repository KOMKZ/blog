# Yii2 Config Usage Practice

## 说明

yii2中关于开发配置和生产环境的解决思路如下：

1. `main.php`配置文件保存线上配置，`main-local.php`文件保存开发配置
2. 通过环境配置文件和执行脚本生成固定格式和初始化的配置文件`main-local.php`等

根据上诉的原则，一种安排配置的策略如下：

生产环境配置文件：

```php
<?php
// main.php
return [
  'file_server' => "http:://company.real_file_server.com"
];
```

开发环境本地文件：

```php
<?php
// main-local.php
return [
  'file_server' => 'http://dev.real_file_server.com'
];
```

貌似这种情况很好的解决了这个问题，但是实际上由于`main.php`文件在版本库控制中，信息对于各个开发者是透明的，貌似如下的配置是不应该放入版本控制为透明信息的，

```php
<?php
// main.php
return [
  'wxpay_config' => [
    'password' => 'abc123',
    'key' => "abc"
  ]
];
```

这些配置是必须在线上服务器的`main-local.php`文件中来定义的，但是运维人员实际不知道如何配置这些项目，所以就必须要有初始化的`main-local.php`的模板交给运维人员，也就是环境目录的作用了，`./yii init`能够根据环境设定初始化配置模板到配置目录当中，对于上诉的可以配置模板如下：

```
<?php
// main.php
return [
  'wxpay_config' => [
    'password' => '',
    'key' => "",
    "server" => "http://www.wxpay.com"
  ]  
];
```

环境的模板如下：

```php
<?php
return [
  'wxpay_config' => [
    'password' => 'abc123',
    "key" => 'abc123',
    'server' => 'http://www.wxpay-dev.com'
  ]
];
```

实际开发情况中，由于环境模板一般不会经常初始化（都是在项目开始的时候才初始化），但是开发中常常遇上一个coder开发了这个配置，另外一个coder开发了那个配置，各个coder都需要在自己的环境中配置好自己的dev配置，此时如果直接执行初始化脚本会将现有的本地配置冲掉（实际上dev配置对于不同的开发人员页未必是统一的），所以初始化脚本的应该支持特性：

1. ./yii initconfig dev --merge

该条命令在将会把本地的config同模板的config合并起来，前者覆盖后者，然后重新生成文件。

这样子依赖，开发者只要时刻维持好模板文件的版本就好了。

完！