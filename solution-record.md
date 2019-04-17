# 问题提出记录及方案记录

## nginx
nginx支持跨返回
```
location / {  
    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';

    if ($request_method = 'OPTIONS') {
        return 204;
    }
} 
```

## 文件上传服务器

应该考虑使用nginx upload module来做上传的功能

https://www.nginx.com/resources/wiki/modules/upload/

相关文章：

http://xianglong.me/article/use-nginx-upload-module-to-implement-uploading-file-feature/
