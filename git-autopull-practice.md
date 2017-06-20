# git项目自动更新设置

## deploykey + pullevent-hook的方法

1. 首先在gitlab上新建项目autopull-test
2. 客户端克隆该项目两遍，一个用于开发，一个用于发布。
3. 设置发布项目的权限，主要设置www-data对.git的目录的修改权限
4. 增加update.php
```
<?php
exec("git pull origin master 1>pull.log 2>&1");
```
5. 生成www-data的公钥
```
$ sudo -u www-data ssh-keygen
```
6. 配置ssh
```
$ vim /var/www/.ssh/config
```
加入以下内容：
```
Host 192.168.1.43
RSAAuthentication yes
Port    10022
IdentityFile /var/www/.ssh/id_rsa
User www-data
```
7. 将www-data的public key放置到gitlab的deploykey中，设置面板中有该菜单。
8. 设置项目的webhook，这里设置pull event为勾选，
9. 将update.php访问地址填入到pull event指定的url栏中。
