# PHP Grace Code Fragment

用于获取固定格式字符串的某一部分：

```
list($jwt) = sscanf( $authHeader->toString(), 'Authorization: Bearer %s');
```