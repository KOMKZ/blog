# 工具记录

## 说明

## 使用工具记录

### 命令

#### 快捷键插入当前时间

需要先安装xdotool, 然后手动设置快捷键，如下：

```
bash -c 'sleep 0.3 && xdotool type "$(date -u +%Y-%m-%d\ %H:%M:%S)"'
```

### GIT

常用命令：

```
# 列出分支的文件修改文件列表
git diff branch1 branch2 --stat
```

### php

#### curl老是忘记使用方法

```
$ch = curl_init("http://localhost:8011/trans/notify");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $notifyData);
curl_exec($ch);
curl_close($ch);
```

# 软件设置

## Typora

### 设置标题自动编号

如下:

1. 打开Preferrence
2. 打开主体目录
3. 新建文件github.user.css 注意和当前主体匹配
4. 写入以下内容,见附1
5. 重启

附1:

```
http://support.typora.io/Auto-Numbering/
```

### vpn连接

参考这篇链接，http://blog.csdn.net/u012336923/article/details/50237007

### eslint在atom中相关设置

http://blog.wangdagen.com/2016/09/22/use-eslint-in-atom.html

在atom中很容易遇到space->tab的自动的过程，可以开启visable

