# Ubuntu14/16软件安装

## 软件列表

## 准备工作

所有下载软件放在中，请准备好该目录。

```
$ ~/soft/src
```

所有的个人配置放在下面目录中，请准备好。

```
$ /etc/kzconf/
```

相关的备份放在，请准备好。

```
$ ~/soft/bk
```

php工作项目在下面，请准备好。

```
$ ~/pro/php/
```

log文件如下：

```
$ ~/logs
```



## 安装过程

### 安装Vim

如下：

```
$ sudo apt-get install vim
```

### 安装Git

如下

```
$ sudo apt-get install git
```

### 安装Nginx

如下：

```
$ sudo apt-get install nginx
```

### 安装mysql

14如下：

```
$ sudo apt-get install mysql-server-5.6
```

16如下：

```
$ sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
$ sudo apt-get update
$ sudo apt install mysql-server-5.6 * see note below if you get an error
$ sudo apt install mysql-client-5.6
```



### 安装php5.6

php安装如下：

```
$ sudo apt-get install python-software-properties
$ sudo add-apt-repository ppa:ondrej/php
$ sudo apt-get update
$ sudo apt-get install -y php5.6
```

安装fpm

```
$ sudo apt-get install php5.6-fpm
```

安装mbstring

```
$ sudo apt-get install php5.6-mbstring
```

安装bcmath

```
$ sudo apt-get install php5.6-bcmath
```

安装curl

```
$ sudo apt-get install php5.6-curl
```

安装gd

```
$ sudo apt-get install php5.6-gd
```

安装mcrypt（yii2需要）

```
$ sudo apt-get install php5.6-mcrypt
```

安装mongo

```
$ sudo apt-get install php5.6-mongo
```

安装pdo-mysql

```
$ sudo apt-get install php5.6-pdo-mysql
```

安装xdebug（经常用）

```
$ sudo apt-get install php5.6-xdebug
```

安装dom(phpunit需要这个扩展)

```
$ sudo apt-get install php5.6-dom
```

### 安装Shadowsocks翻墙等代理软件

**安装pip2**

```
$ sudo apt-get install python-pip
$ pip install --upgrade pip
```

**安装shadowsocks**

```
$ sudo pip2 install shadowsocks
```

新建配置

```
$ sudo vim /etc/kzconf/sslocal.conf
```

输入以下内容：

```
{
  "server":"",
  "server_port":,
  "local_port":,
  "password":"",
  "method":"",
  "timeout":,
  "remarks":""
}
```

启动代理服务

```
$ sslocal -c /etc/kzconf/sslocal.conf
```

设置开机启动

```
todo
```

或者直接后台运行：

```
sslocal -c /etc/kzconf/sslocal.conf > /dev/null 2>%1 &
```

**安装proxychains4**

这是一个命令行的代理工具, 编译安装，在clone下来的时候超慢，诸君请耐心等候。

```
$ cd ~/soft/src
$ git clone https://github.com/rofl0r/proxychains-ng
$ cd proxychains-ng
$ ./configure --prefix=/usr --sysconfdir=/etc
$ sudo make install
$ sudo make install-config
```

如果真的下载不下来，点我这个下载（todo）, 安装完成之后修改配置

```
$ sudo vim /etc/proxychains.conf
$ sudo mv /etc/proxychains.conf /etc/kzconf/
```

最后一行使用代理地址和端口和协议修改为：

```
socks5 127.0.0.1 1080
```

测试一下：(注意sslocal已经运行)

```
$ proxychains4 -f /etc/kzconf/proxychains.conf telnet google.com 80
```

使用方式就是：`proxychains4 -f {配置文件} 命令 命令的参数`

### 安装Composer

如下：(下载时间可能有些久，也可以单独把网址拿出来下载)

```
$ cd ~/soft/src
$ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
$ proxychains4 -f /etc/kzconf/proxychains.conf php composer-setup.php
```

等待下载成功，然后执行一下命令，测试是否已经安装成功。

```
$ sudo rm composer-setup.php
$ sudo chmod a+x composer.phar
$ sudo mv composer.phar /usr/bin/composer
$ composer
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 1.4.2 2017-05-17 08:17:52
```

### 安装typora
typora是一个清爽的md编辑器，谁用谁爽，安装如下：（网速过慢请自行拿梯子，如proxychains）

```
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE

$ sudo add-apt-repository 'deb https://typora.io ./linux/'
$ sudo apt-get update

$ sudo apt-get install typora
```

### 安装atom

超爱的编辑器：

```
$ cd ~/soft/src
$ mkdir atom
$ cd atom
$ proxychains4 -f /etc/kzconf/proxychains.conf wget https://atom.io/download/deb
$ sudo dpkg -i deb
```

### 安装QQ国际版

安装wine

```
$ sudo apt-get install wine
```

wine-qqintl





### 安装mysql-workbench

又是一个命令就搞定

```
$ sudo apt-get install mysql-workbench
```



### 安装Chrome

如下：

```
$ cd ~/soft/src
$ mkdir chrome
$ cd chrome
$ proxychains4 -f /etc/kzconf/proxychains.conf wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ sudo dpkg -i google-chrome-stable_current_amd64.deb
```

### 安装Chrome插件/应用

安装advanced rest client

安装gliffy diagrams

安装

### 安装有道词典

如下：

```
$ mkdir ~/soft/src/yodao
$ cd ~/soft/src/yodao
$ wget http://codown.youdao.com/cidian/linux/youdao-dict_1.1.0-0-deepin_amd64.deb
$ sudo dpkg -i youdao-dict_1.1.0-0-deepin_amd64.deb
```



### 安装gitkraken

这是git的一个Node.js客户端,效果还不错，可以用用

```
$ cd ~/soft/src
$ mkdir gitkraken
$ cd gitkraken
$ proxychains4 -f /etc/kzconf/proxychains.conf wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
$ sudo dpkg -i gitkraken-amd64.deb
```







## 配置

### 配置LNMP及测试

首先建立一个测试文件,然后保存

```
$ vim /usr/share/nginx/html/index.php
<?php
echo "hello world\n";
```

备份一下配置

```
$ sudo cp /etc/nginx/sites-enabled/default ~/soft/bk/conf/nginx.sites-enabled.default
$ sudo vim /etc/nginx/sites-enabled/default
```

注意fpm sock文件的位置，修改配置如下：

```
server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;
	root /usr/share/nginx/html;
	index index.php index.html index.htm;
	server_name localhost;
	location / {
		try_files $uri $uri/ =404;
	}
	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php/php5.6-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}
```

重启动一下服务：

```
$ sudo service php5.6-fpm restart
$ sudo nginx -s reload
```

测试：

```
$ curl -XGET 'http://localhost/index.php'
```

### 配置自己的项目

配置公钥, 然后放在需要放的地方，事实证明很多地方要用到。

```
$ ssh-kengen
$ cat ~/.ssh/id_rsa.pub
```

创建数据库

```
$ sudo service mysql start
$ mysql -uroot -p
create database dull DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
```

设置nginx配置，这两个文件的作用是开端口建立新的web访问目录，然后做一些特定配置。

```
$ vim /etc/nginx/sites-enabled/dull-fe
$ vim vim /etc/nginx/sites-enabled/dull-be
```



克隆自己的项目到工作目录, （我已经将公钥放在自己项目的github上了）

```
$ cd ~/pro/php
$ git clone git@github.com:KOMKZ/dull.git
$ cd dull
$ ./yii

```
