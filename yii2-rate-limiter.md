yii2 rate limiter

说明:

1. yii2的rate limiter机制是基于user的，准确来说就是用户请求的访问限制，没有实现ip的访问限制
2. 基本思路就是每次请求记录减掉一次请求数量，等于0的时候就抛429, 或者等待下个周期重新重置为最大值。

实现：

控制器加上对应行为：

```php
	public function behaviors(){
		$behaviors = parent::behaviors();
		return array_merge($behaviors, [
			'rateLimiter' => [
				'class' => \yii\filters\RateLimiter::className(),
			],
		]);
	}
```

然后对User实现三个方法：

```
// 返回 周期时间内最大的请求数量， 如 [60, 600], 表示600秒能够请求的最多次数60次
public function getRateLimit($request, $action);
// 返回当前允许的数量， 以及当前时间戳， 如 [59, 1592661546]
// 判断是否有记录，没有则创建
// 判断是否需要重新置为初始值
public function loadAllowance($request, $action);
// 实时更新用户能够请求的次数还有上次的请求的时间
public function saveAllowance($request, $action, $allowance, $timestamp);
```

