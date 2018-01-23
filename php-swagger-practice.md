# Php Api Practice Base On Swagger Tools

## 预安装

安装swagger-ui，这个工具可以对约定api-json文件可以生成api请求页面工具，安装说明如下：

1. 准备swagger-ui目录，克隆项目：

   ```
   https://github.com/swagger-api/swagger-ui
   ```

2. 将项目放在web目录下，类似的访问地址如：

   ```
   http://localhost/swg/swagger-ui/dist
   ```

   第一次运行有个demo文件用于展示，你可以修改自己的api-json文件

   注：

   1. 可能有跨域问题

3. 一些简单的配置：

   1. 修改body参数为可以编辑, 修改 index.html 然后设置 jsonEditor:true



安转php-swagger，swagger最终解析的是json文件，拥有固定的语法来书写这个api-json文件，当然也可以通过书写yaml文件来转成json，而php-swagger是使用php注释的方法来书写api说明，最终也是转成json文件，通过以下安装php-swagger:

```
composer global require zircote/swagger-php
```

这里选择使用全局安装，因为我们最终是使用来其命令来生成对应的json文件。

## swagger语法 VS php-swagger语法

swagger语法不介绍，官网文档已经足够，这里介绍php-swagger最常用的语法。

**首先介绍一下目录安排：**

```
├── root.php 			：放置全局信息
└── user				：用户模块api-swagger-doc
    ├── get-user.php	：获取单个用户doc
    ├── post-user.php	：创建单个用户doc
    ├── public.php		：公共定义，如返回的用户数据结构定义
    ├── put-user.php	：修改单个用户doc
    └── query-user.php	：查询用户doc
```

**书写swagger注意：**

1. <?php文件开头
2. 逗号严格要求，不要在不该有逗号的地方有逗号，如json一样

**生成json文件命令:**

```
./swagger ./swg --output index.json
```

**贴下各个文件的基本内容：**

root.php如下：

```
<?php
/**
 * @SWG\Swagger(
 *      host="localhost",
 *      schemes={"http"},
 *      produces={"application/json"},
 *      consumes={"application/json"},
 *      basePath="/",
 *		@SWG\Info(
 *         version="1.0.0",
 *         title="地域亡人服务",
 *         description="地域亡人服务"
 *		)
 * )
 */
```

public.php如下：

```
<?php
/**
* @SWG\Definition(
*       definition="UserSchema",
* 		@SWG\Property(
* 			property="user_id",
* 			type="integer",
*           format="int32",
* 			description="未亡人id"
* 		),
* 		@SWG\Property(
* 			property="user_name",
* 			type="string",
* 			description="未亡人名称"
* 		),
* 		@SWG\Property(
* 			property="user_level",
* 			type="string",
* 			description="未亡人级别",
*   		enum={"super", "normal", "little"},
*      	    description="亡人级别, super:超级， normal:一般, little:辣鸡"
* 		)
* )
*/

/**
* @SWG\Definition(
*       definition="PostUserData",
* 		@SWG\Property(
* 			property="user_name",
* 			type="string",
* 			description="未亡人名称"
* 		),
* 		@SWG\Property(
* 			property="user_level",
* 			type="string",
* 			description="未亡人级别",
*   		enum={"super", "normal", "little"},
*      	    description="亡人级别, super:超级， normal:一般, little:辣鸡"
* 		)
* )
*/

/**
* @SWG\Definition(
*       definition="PutUserData",
* 		@SWG\Property(
* 			property="user_name",
* 			type="string",
* 			description="未亡人名称"
* 		),
* 		@SWG\Property(
* 			property="user_level",
* 			type="string",
* 			description="未亡人级别",
*   		enum={"super", "normal", "little"},
*      	    description="亡人级别, super:超级， normal:一般, little:辣鸡"
* 		)
* )
*/

```



get-user.php

```
<?php
/**
 * @SWG\Get(
 * 	path="/user/{id}",
 * 	tags={"User"},
 * 	operationId="get-user",
 * 	summary="根据id获取一个亡人信息",
 * 	produces={"application/json"},
 * 	@SWG\Parameter(
 * 		 	 name="user_id",
 *   		 type="integer",
 *      	 format="int32",
 *      	 in="path",
 *      	 required=true,
 *      	 description="亡人id"
 * 	),
 * 	@SWG\Parameter(
 * 		 	 name="user_level",
 *   		 type="string",
 *   		 enum={"super", "normal", "little"},
 *      	 in="query",
 *      	 description="亡人级别, super:超级， normal:一般, little:辣鸡"
 * 	),
 *  @SWG\Response(
 *   		response=200,
 *   		description="上传成功返回结果",
 *   		@SWG\Schema(
 *              @SWG\Property(
 *        			property="code",
 *        			type="string",
 *        			description="错误代码"
 *              ),
 *              @SWG\Property(
 *                  property="message",
 *                  type="string",
 *                  description="错误信息"
 *             ),
 *             @SWG\Property(
 *                  property="data",
 *                  type="array",
 *                  ref="#/definitions/UserSchema",
 *                  description="亡人信息"
 *             )
 *   		)
 *   	)
 * )
 */

```



post-user.php

```
<?php
/**
 * @SWG\Post(
 * 	path="/user",
 * 	tags={"User"},
 * 	operationId="post-user",
 * 	summary="创建一个亡人",
 * 	produces={"application/json"},
 * 	@SWG\Parameter(
 * 	    name="body",
 *      in="body",
 *      required=true,
 *   	@SWG\Schema(
 *   	  ref="#/definitions/PostUserData"
 *   	)
 * 	),
 *  @SWG\Response(
 *   		response=200,
 *   		description="上传成功返回结果",
 *   		@SWG\Schema(
 *              @SWG\Property(
 *        			property="code",
 *        			type="string",
 *        			description="错误代码"
 *              ),
 *              @SWG\Property(
 *                  property="message",
 *                  type="string",
 *                  description="错误信息"
 *             ),
 *             @SWG\Property(
 *                  property="data",
 *                  type="array",
 *                  ref="#/definitions/UserSchema",
 *                  description="亡人信息"
 *             )
 *   		)
 *   	)
 * )
 */

```



put-user.php

```
<?php
/**
 * @SWG\Put(
 * 	path="/user/{id}",
 * 	tags={"User"},
 * 	operationId="put-user",
 * 	summary="根据id获取修改亡人信息",
 * 	produces={"application/json"},
 * 	@SWG\Parameter(
 * 		 	 name="user_id",
 *   		 type="integer",
 *      	 format="int32",
 *      	 in="path",
 *      	 required=true,
 *      	 description="亡人id"
 * 	),
 * 	@SWG\Parameter(
 * 	    name="body",
 *      in="body",
 *      required=true,
 *   	@SWG\Schema(
 *   	  ref="#/definitions/PutUserData"
 *   	)
 * 	),
 *  @SWG\Response(
 *   		response=200,
 *   		description="上传成功返回结果",
 *   		@SWG\Schema(
 *              @SWG\Property(
 *        			property="code",
 *        			type="string",
 *        			description="错误代码"
 *              ),
 *              @SWG\Property(
 *                  property="message",
 *                  type="string",
 *                  description="错误信息"
 *             ),
 *             @SWG\Property(
 *                  property="data",
 *                  type="array",
 *                  ref="#/definitions/UserSchema",
 *                  description="亡人信息"
 *             )
 *   		)
 *   	)
 * )
 */
```



query-user.php

```
<?php
/**
 * @SWG\Get(
 * 	path="/user",
 * 	tags={"User"},
 * 	operationId="query-user",
 * 	summary="查询亡人",
 * 	produces={"application/json"},
 * 	@SWG\Parameter(
 * 		 	 name="user_id",
 *   		 type="integer",
 *      	 format="int32",
 *      	 in="path",
 *      	 required=true,
 *      	 description="亡人id"
 * 	),
 * 	@SWG\Parameter(
 * 		 	 name="user_level",
 *   		 type="string",
 *   		 enum={"super", "normal", "little"},
 *      	 in="query",
 *      	 description="亡人级别, super:超级， normal:一般, little:辣鸡"
 * 	),
 *  @SWG\Response(
 *   		response=200,
 *   		description="上传成功返回结果",
 *   		@SWG\Schema(
 *              @SWG\Property(
 *        			property="code",
 *        			type="string",
 *        			description="错误代码"
 *              ),
 *              @SWG\Property(
 *                  property="message",
 *                  type="string",
 *                  description="错误信息"
 *             ),
 *             @SWG\Property(
 *                  property="data",
 *                  type="object",
 *                  @SWG\Property(
 *                  	type="array",
 *                  	property="items",
 *                      @SWG\Items(
 *                  	   type="object",
 *                   	   ref="#/definitions/UserSchema"
 *                      )
 *                  ),
 *                  @SWG\Property(
 *                  	type="integer",
 *                  	property="total_count",
 *                  	format="int32"
 *                  )
 *             )
 *   		)
 *   	)
 * )
 */
```

## 更加简洁的写法

### 语法说明

想象将`php-swagger`的内容加入到我们php文件中，多么大的一陀shi啊，考虑以下写法是不是非常的清爽呢！

**全局信息：**

```
/**
 * @root
 * - host localhost:8064
 * - version 1.0.0
 * - title 安全家接口swagger
 * - description 安全家接口swagger
 * - Contact name="Trainor Technical Service (Shenzhen)Ltd.", url="http://www.trainor.cn"
 * - License name="Trainor Technical Service (Shenzhen)Ltd.", url="http://www.trainor.cn"
 * - basePath /
 * - schemes http
 */
```

注：

* 只支持上诉的属性

**引用信息**

```
/**
 * @def #service_order
 * - od_id integer,服务订单id
 * - od_title string,服务订单标题
 * - od_status integer,服务订单状态，{{enum_des:s_od_status}}
 */
```

注：

* 使用以下来申明一个引用

  ```
   @def #{DEF_NAME} 
  ```

* 属性的语法是

  ```
  - {PROP_NAME} [required|optional],{TYPE},{DES}
  ```

**api信息**

```
/**
 * @api get,/service-order/{id},ServiceOrder,获取订单编号获取一个服务订单
 * - id required,integer,in_path,服务订单编号
 * - od_belong_uid optional,integer,in_query,服务订单买家huid
 * - od_earning_uid optional,integer,in_query,服务订单卖家huid
 * @return #global_res
 * - data object#service_order,返回服务订单信息
 */
```

### 安装

这个语法解析可以使用以下命令

```
./yii doc/gene-api {module} --update=0
```

上述命令表示对指定的module生成swagger.json，然后更新到版本库中,`params-local.php`配置如下：

```
    'enumcmd' => 'kzcmd file/enums-str enums.yaml enums-str.php',
    'svn_swg_json' => [
        'service' => "/2.0/模块/服务模块/服务订单0.2/swagger.json",
    ],
    'apifiles' => [
        'service' => [
            '@hsefr/docs/root.php',
            '@hsefr/controllers/ServiceOrderController.php',
            '@hsefr/controllers/ServiceRefundApplicationController.php'
        ]
    ]
```

再贴一下enums.yaml的内容：

```
-
    name: 订单支付类型
    field: od_pay_type
    items:
        - wxpay|微信支付
        - alipay|支付宝支付
        - balance_pay|余额支付
        - hsebpay|安全币支付
```

