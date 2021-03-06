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

### 安装svn

如下：

```
$ sudo apt-get install subversion
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

### 安装mongo

如下：

参考地址：

```
https://docs.mongodb.com/v3.0/tutorial/install-mongodb-on-ubuntu/
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

### 小命令唤起所有的窗口

python3支持是必需的,然后安装下面这个

```
sudo add-apt-repository ppa:vlijm/upfront
sudo apt-get update
sudo apt-get install upfront
```

新建个脚本保存为raise.py

```
#!/usr/bin/env python3
import signal
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('AppIndicator3', '0.1')
from gi.repository import Gtk, AppIndicator3, GObject
import time
from threading import Thread
import os
import subprocess
import getpass

currpath = os.path.dirname(os.path.realpath(__file__))

class Indicator():
    def __init__(self):
        self.app = 'raise_apps'
        iconpath = os.path.join(currpath, "raise.png")
        self.indicator = AppIndicator3.Indicator.new(
            self.app, iconpath,
            AppIndicator3.IndicatorCategory.OTHER)
        self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)       
        self.indicator.set_menu(self.create_menu())
        # the thread:
        self.update = Thread(target=self.check_recent)
        # daemonize the thread to make the indicator stopable
        self.update.setDaemon(True)
        self.update.start()

    def create_menu(self):
        # creates the (initial) menu
        self.menu = Gtk.Menu()
        # separator
        initial = Gtk.MenuItem("Fetching list...")
        menu_sep = Gtk.SeparatorMenuItem()
        self.menu.append(initial)
        self.menu.append(menu_sep)
        # item_quit.show() 
        self.menu.show_all()
        return self.menu

    def raise_wins(self, *args):
        index = self.menu.get_children().index(self.menu.get_active())
        selection = self.menu_items2[index][1]
        for w in selection:
            execute(["wmctrl", "-ia", w])

    def set_new(self):
        # update the list, appearing in the menu
        for i in self.menu.get_children():
            self.menu.remove(i)
        for app in self.menu_items2:

            sub = Gtk.MenuItem(app[0])
            self.menu.append(sub)
            sub.connect('activate', self.raise_wins)
        # separator
        menu_sep = Gtk.SeparatorMenuItem()
        self.menu.append(menu_sep)
        # quit
        item_quit = Gtk.MenuItem('Quit')
        item_quit.connect('activate', self.stop)
        self.menu.append(item_quit)
        self.menu.show_all()

    def get_apps(self):
        # calculate screen resolution
        res_output = get("xrandr").split(); idf = res_output.index("current")
        res = (int(res_output[idf+1]), int(res_output[idf+3].replace(",", "")))
        # creating window list on current viewport / id's / application names
        w_data = [l.split() for l in get(["wmctrl", "-lpG"]).splitlines()]
        # windows on current viewport
        relevant = [w for w in w_data if 0 < int(w[3]) < res[0] and 0 < int(w[4]) < res[1]]
        # pids
        pids = [l.split() for l in get(["ps", "-u", getpass.getuser()]).splitlines()]
        matches = [[p[-1], [w[0] for w in relevant if w[2] == p[0]]] for p in pids]
        return [m for m in matches if m[1]]

    def check_recent(self):
        self.menu_items1 = []
        while True:
            time.sleep(4)
            self.menu_items2 = self.get_apps()
            for app in self.menu_items2:
                app[0] = "gnome-terminal" if "gnome-terminal" in app[0] else app[0]
            if self.menu_items2 != self.menu_items1:
                GObject.idle_add(
                    self.set_new, 
                    priority=GObject.PRIORITY_DEFAULT
                    )
            self.menu_items1 = self.menu_items2

    def stop(self, source):
        Gtk.main_quit()

def get(command):
    return subprocess.check_output(command).decode("utf-8")

def execute(command):
    subprocess.Popen(command)

Indicator()
GObject.threads_init()
signal.signal(signal.SIGINT, signal.SIG_DFL)
Gtk.main()
```

然后在保存一个文件,作为图标:

```
https://i.stack.imgur.com/XgzYu.png
```

运行,可以修改脚本只用于唤起terminal

```
python3 raise.py
```

原本:

https://askubuntu.com/questions/446521/how-to-show-raise-all-windows-of-an-application

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

sometimes would come with error, and your can slove that by following this [link](https://blog.lyz810.com/article/2016/09/shadowsocks-with-openssl-greater-than-110/)
```
AttributeError: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup
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

### 安装rabbitmq

参考文章:

```
https://www.rabbitmq.com/install-debian.html
```

如下:

```
sudo apt-get update
sudo apt-get install erlang
sudo apt-cache policy
echo 'deb http://www.rabbitmq.com/debian/ testing main' |
     sudo tee /etc/apt/sources.list.d/rabbitmq.list
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc |
     sudo apt-key add -
sudo apt-get update
sudo apt-get install rabbitmq-server
```

安装成功后服务就已经启动了.

开启插件:

```
rabbitmq-plugins enable rabbitmq_management
```

然后可以通过, 密码和用户都是guest

```
http://localhost:15672/#/
```



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

编辑器插件：

```
docblockr
emmet
linter-php
minimap
php-debug
qolor
```



### 安装QQ国际版

安装wine

```
$ sudo apt-get install wine
```

wine-qqintl



### 安装elasticsearch2.4

参考文档：

```
// 官方安装说明
https://www.elastic.co/guide/en/elasticsearch/reference/2.4/_installation.html
```

依赖java，需要先安装java（注java7不再支持了，安装8），这个下载还是相对久的,请自觉搬梯子。

```
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ proxychains4 -f /etc/kzconf/proxychains.conf sudo apt-get install oracle-java8-installer
```

 安装一下java的打包工具：

```
$ sudo apt install maven
```

首先下载软件：

```
$ cd ~/soft/src; mkdir es; cd es;
$ proxychains4 -f /etc/kzconf/proxychains.conf wget  https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.3/elasticsearch-2.4.3.tar.gz
$ tar -xvf elasticsearch-2.4.3.tar.gz
```
### 安装elasticsearch2.4插件

#### ik中文分词

[ik中文分词](https://github.com/medcl/elasticsearch-analysis-ik)

首先克隆仓库下来：

```
$ cd ~/soft/src; mkdir es-p; cd es-p;
$ git clone https://github.com/medcl/elasticsearch-analysis-ik
$ cd elasticsearch-analysis-ik
```

es2.4.3版本对应这个插件的版本是1.10.3

```
$ git checkout v1.10.3
$ mvn package
```

复制jar包到es的插件目录，谢谢：(proxy是proxychains的shell)

```
$ proxy mvn package
```

然后复制插件到插件目录中：

```
$ cd ~/soft/target/elasticsearch-2.4.3/plugins/;mkdir ik;cd ik
$ unzip ~/soft/src/es-p/elasticsearch-analysis-ik/target/releases/elasticsearch-analysis-ik-1.10.3.zip -d ./
```

回到es目录，启动服务，没报错就是安装成功

```
$ cd ~/soft/target/elasticsearch-2.4.3/
$ ./bin/elasticsearch 
```

####  ik拼音

[下载](https://github.com/medcl/elasticsearch-analysis-pinyin/tree/v1.8.3)

```
$ cd ~/soft/src/es-p/
$ proxy git clone https://github.com/medcl/elasticsearch-analysis-pinyin
$ cd elasticsearch-analysis-pinyin
```

checkout到对应的版本号：(proxy是proxychains的shell)

```
$ git checkout v1.8.3
$ proxy mvn package
```

安装到es的插件目录

```
$ cd ~/soft/target/elasticsearch-2.4.3/plugins;mkdir ik-pinyin;cd ik-pinyin
$ unzip ~/soft/src/es-p/elasticsearch-analysis-pinyin/target/releases/elasticsearch-analysis-pinyin-1.8.3.zip -d ./
```

回到es目录，启动服务，没报错就是安装成功

```
$ cd ~/soft/target/elasticsearch-2.4.3/
$ ./bin/elasticsearch 
```

#### lc拼音

[下载](https://github.com/gitchennan/elasticsearch-analysis-lc-pinyin)

如下：

```
$ proxy git clone https://github.com/gitchennan/elasticsearch-analysis-lc-pinyin
$ git checkout v2.4.2.1
$ cd elasticsearch-analysis-lc-pinyin/target
$ vim pom.xml
```

然后修改es的版本

### 安装mysql-workbench

又是一个命令就搞定

```
$ sudo apt-get install mysql-workbench
```



### 安装服务管理软件

如下：

```
$ sudo apt-get install sysv-rc-conf
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

安装switchomega,自动切换规则的网址如下：

https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt

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

### 镜像制作工具

如下：

```
$ sudo add-apt-repository ppa:sergiomejia666/respin
$ sudo add-apt-repository ppa:sergiomejia666/xresprobe
$ sudo apt install xresprobe
$ sudo apt install respin
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
```

使用composer安装依赖：

```
// 下面这一步很重要
$ sudo proxychains4 -f /etc/kzconf/proxychains.conf composer global require "fxp/composer-asset-plugin:^1.2.0"
$ proxychains4 -f /etc/kzconf/proxychains.conf composer update
```

