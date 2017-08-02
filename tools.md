# 工具记录

## 说明

## 使用工具记录

### 命令

#### 快捷键插入当前时间

需要先安装xdotool, 然后手动设置快捷键，如下：

```
bash -c 'sleep 0.3 && xdotool type "$(date -u +%Y-%m-%d\ %H:%M:%S)"'
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

