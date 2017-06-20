# Codeception实践

## 准备

1. 确保应经拥有以下package
```
    "require-dev": {
        "codeception/codeception" : "*",
        "codeception/specify" : "*",
        "codeception/verify" : "*"
    },
```
其中 codeception/codeception， 这个包你可以全局安装。
2. 准本好测试项目的目录
   codeception支持一次性执行多个应用的测试，可以参考上篇文章进行目录部署。
3. 初始话单元测试的配置
   假设当前的目录是项目根目录, 使用上篇文章的文件结构，有一个应用叫做frontend,执行以下命令:
```
$ cd tests/codeception/frontend
$ vim unit.suite.yml  
```
unit.suite.yml的内容如下
```
class_name: UnitTester
modules:
    enabled:
        - Asserts
        - PhpBrowser
        - tests\codeception\frontend\Helper\MyHelper
    config:
        PhpBrowser:
            url: http://localhost
```
由于我的单元测试需要请求一些页面，所以我开启了PhpBrowser，同时你发现我增加了一个自定义的模块MyHelper, 你可以通过执行命令先生成自定义模块，然后在加入模块到配置中，如：
```
$ codecept g:helper MyHelper
```
以下是MyHelper的内容：
```
<?php
namespace tests\codeception\frontend\Helper;
// here you can define custom actions
// all public methods declared in helper class will be available in $I
class MyHelper extends \Codeception\Module
{
    public function console($data){
        return $this->debug($data);
    }
}
```
保存好MyHelper的内容之后，需要执行build，扩展Actor：
```
$ codecept build
```
在MyHelper中我增加了一个自定义的方法，在内置方法debug(protected)的外面包了一层,这样子在你就可以这样调用了：
```
$data = ['something to debug'];
// in acceptance test
$I->console($data);
// in unit test
$this->tester->console($data);
```
接着运行测试的时候，加上参数-vv就能够得到调试的信息了，非常方便。
4. 新建一个单元测试
```
$ codecept g:test unit FileServerTest
```

## 编写单元测试前

上一步生成一个文件，该文件在：
```
$ ./tests/codeception/frontend/unit/FileServerTest.php
```
我们可以看一下这个文件：
```
<?php
namespace tests\codeception\frontend;
class FileServerTest extends \Codeception\Test\Unit{
    use \Codeception\Specify;
    protected $tester;
}
```
这个小结主要说明在单元测试中，到底支持什么特性，有哪些现成的方法，毕竟codeception是希望我们集中写测试代码，而不是重复造一些工具去支持测试，能够用的特性总结如下
1. hpunit assetions
   你查看代码你会发现\Codeception\Test\Unit， 这个类最终继承的是phpunit 的 PHPUnit_Framework_Assert 类，所以可以这样调用：
```
$this->assertTrue($expectBoolValue, "some message output when assets failed")
```
2. codeception actor methods, including methods extend from module.
   假设开启了PhpBrowser模块
```
$this->tester->amOnUrl("http://hostname/path_to_web/entry_file");
```
假设开启了MyHelper模块：
```
$this->tester->console($debugData);
```
3. bdd style test method,  by use Codeception/Specify
   这个包能够让你增加更可读的描述在一个测试中，同时在测试运行发现fail的时候将获得更友好的显示：
```
$this->specify('more detail information for step of one test', function(){
// something test here
});
```
4. bdd style By use Codeception/Verify
   这是另外一种风格的测试书写，但是我发现输出不友好，当然你也可以组合起来使用
```
$this->specify("description", function(){
       expect($valueGot)->equals($valueExpect);
});
```


我贴出一些连接供学下：
1. [phpunit assetions](https://phpunit.de/manual/current/en/phpunit-book.html)
2. 关于第二点主要需要了解Codeception中的Actor到底是什么东西，Actor类能够用module里的方法，只要在配置打开了该模块。
3. [Codeception\Specify](https://github.com/Codeception/Specify)
4. [Codeception/Verify](https://github.com/Codeception/Verify)

## 一个例子
