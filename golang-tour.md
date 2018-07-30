# Golang 填坑记

## 学习点记录

**struct fields tag**

https://sosedoff.com/2016/07/16/golang-struct-tags.html

**type assetion**

![1525416115497](/home/lartik/img/note_img/1525416115497.png)



## Glide不能说之痛 

golang.com/x 上面的package由于墙的问题导致glide死慢，好，我有sslocal + proxychains4 啊，真他妈天真我，glide在proxychains4不能接受socks5返回，亲测只能http的代理返回，行，fuck，解决如下：

```
apt-get install privoxy -y
mv /etc/privoxy/config /etc/privoxy/config.bak
vim /etc/privoxy/config

​```
# 转发地址
forward-socks5   /               127.0.0.1:1080 .
# 监听地址
listen-address  localhost:8118
# local network do not use proxy
forward         192.168.*.*/     .
forward            10.*.*.*/     .
forward           127.*.*.*/     .
​```

# 启动
systemctl start privoxy
# 查看状态
systemctl status privoxy

vim /usr/local/bin/proxy
​```
#!/bin/bash
http_proxy=http://127.0.0.1:8118 https_proxy=http://127.0.0.1:8118 $*
​```
chmod +x /usr/local/bin/proxy
proxy glide install go1.6.3
```

## OpenCv + Gocv安装

安装完成发觉opencv是个大坑，直接类崩放弃。