# php-amqp-client阅读笔记

## questions

1. 连接keepalive？
2. AMQP\x00\x00\x09\x01, why 16


## consideration

amqp协议是基于二进制数据和ascii码混合的，为什么要用而二进制数据呢？因为ascii码不能准确的表达
出其他的类型，当然也可以设计，但是parse过程就太慢了，还不如直接使用二进制数据，然后规定好长度。
因为不同类型的二进制数据一般而言都是可以就确定的。


应用层协议所以需要制定自己的数据类型，以便兼容machine，协议上应该有一层接口用于特定类型的数据的创建
（这里可以查看AMQPWriter）

注意一点，unicode编码的中文字符占到3个字节，普通的字母占到一个字节，也就是说
当将unicode编码的字符使用ascii编码保存的时候，32位，也就是6位十六进制，0x000000,其中每两位一个字节
在socket流中，我们依靠读取帧的方式正确读取到个帧，然后读取到正确的payload，payload中就是dataField

注意，对于一个connection的连接，他继承的是一个channel选项，代码这样安排是因为协议中规定，channel_0这个
管道是全局共享的，也就是这个管道就是connection，普通的channel在实例化的时候都有x_open的请求，而connection
也是有x_open的请求，两者本质上两种class的x_open

## negotiation

如下：

* 客户端发起一个连接：
    * 连接成功
    * 版本交谈
        * 发送amqp_protocol_header : AMQP\x00\x00\x09\x01
        * 等待服务端返回响应, 正常话会返回一个方法frame，执行到connection_start
            * 读取帧，unpack帧的class-id,frame-id
            * 读取方法帧的args
            * 读取content内容，需要有content内容的只有几个，connection_start是不需要的
              (这一步中已经知道了具体是什么class，哪个method，还有对应的参数，那么接下来就是调用相关的方法了)
            * 根据上面的参数动态调用class的method，然后传入args执行
            * 终于调用了AbstractConnection::connection_start方法
              收到服务端的过来的参数是这些
              ```
              $this->version_major = $args->read_octet();
              $this->version_minor = $args->read_octet();
              $this->server_properties = $args->read_table();
              $this->mechanisms = explode(' ', $args->read_longstr());
              $this->locales = explode(' ', $args->read_longstr());
              ```
        * connection_start 这一步如果没有意外的话就会x_start_ok,此时客户端需要发送一个想应应给
          服务端，即流程 connection.start_ok,
          在这个流程中，客户端告诉服务端客户端的信息，选择某些选项，如安全机制，接着发送登录信息
          等待服务端发送 , 如果选择的是SASL机制则等待Secure方法，
        * 为什么todo（直接跳过secure）
        * 接受到tune方法帧，这个帧用于谈判，前面客户端和服务端交换了信息，现在需要达成一致，就是这个过程
          The client accepts or lowers these parameters, 接受的参数有：
          ：channel_max
          ：frame_max
        * x_open
        * x_open_ok
*  客户端新建一个channel，注意目前管道的数量是1, index为0,代表connection这个channel，此时新建一个管道应该是
   1,
   * 发送x_open
     * protocolWriter构造出需要发送的东西
   * 等待x_open_ok

* 客户端新建一个queue,
  发送方法帧Queue.declare
  等待Queue.declare_ok,然后使用
