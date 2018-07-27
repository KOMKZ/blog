# 开始使用

## 添加任务

### 使用案例

```
// 直接添加一个没有时间范围的任务
dodo add 完成商品模块设计

// 添加一个起始时间的任务
dodo add 完成商品模块设计 --start=now --end=3day
dodo add 完成商品模块设计 --start=now+1day
dodo add 完成商品模块设计 --start=2018-02-12|20:00:00 --end=2018-02-13

// 添加一个具有优先级的任务
dodo add 完成商品模块设计 --order=high
dodo add 完成商品模块设计 --order=9

// 给任务添加描述
dodo set-des "实现sku的模型"  --index=@latest
dodo set-des "能够展示多种价格" --append=1 --index=cfabca

// 给任务增加要素
dodo set-child "设计相关数据表" --index=@latest
dodo set-child "实现代码|实现测试" --multi=1 --index=cfabca

// 清空任务要素
dodo kill-child --index=@latest-1
```

### 完整相关参数

```

```

