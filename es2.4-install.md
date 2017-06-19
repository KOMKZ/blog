# 安装elasticsearch2.4及一些插件

## 安装elasticsearch2.4

依赖java，需要先安装java

```

```

首先下载软件：

```
$ cd ~/soft/src
$ mkdir es
$ cd es
$ proxychains4 -f /etc/kzconf/proxychains.conf wget  https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.3/elasticsearch-2.4.3.tar.gz
$ tar -xvf elasticsearch-2.4.3.tar.gz
```



## 安装插件

### **elasticsearch-analysis-pinyin**

[github地址](https://github.com/medcl/elasticsearch-analysis-pinyin)

