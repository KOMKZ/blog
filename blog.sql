CREATE DATABASE `blog` CHARACTER SET utf8 COLLATE utf8_general_ci;

drop table if exist `post`;
create table `post`(
  id int(10) unsigned not null AUTO_INCREMENT COMMENT 'id',
  title varchar(64) not null comment '标题名称',
  create_uname varchar(64) not null comment '用户昵称',
  content text not null comment '文章内容',
  created_at int(10) unsigned not null comment '创建时间',
  primary key (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='文章表';

insert into post values (null,"安全事故新闻：碧桂园项目工地频曝安全事故 “高周转”再遭质疑", "李强", "27日午时，碧桂园官方微博发布“关于六安事件的声明”表示，对于本次灾害事故造成的伤亡，公司上下深感悲痛，集团副总裁、区域负责人已连夜赶到现场，专门成立了应急小组，全力协助政府展开救援和伤员救治，并对项目进行停工，全面排查安全隐患。当日晚些时候，碧桂园集团针对近期发生的工地安全事故，回复新浪财经称，公司已经通知所有施工合作单位立即停工，彻底排查和整改安全隐患，并称包含工程红线以外的施工队临时设施都应纳入本次检查整改范围。事实上，根据碧桂园针对六安项目发布的声明，此次发生坍塌事故导致伤亡的即为项目红线外总包施工人员居住的活动板房。一石激起千层浪，碧桂园六安项目事故仿佛成为导火索，之后网络上关于多地碧桂园施工现场事故的消息持续发酵。记者注意到，此次碧桂园六安项目事故距离上次该公司建筑工地发生伤亡事故仅一月有余。6月24日下午16时40分许，上海市一个碧桂园小区在建工地发生事故，导致一死九伤。央视新闻于6月25日对此进行了报道。此外，今年以来，碧桂园各地在建项目频曝安全事故，引起各方关注。4月7日，广西崇左碧桂园项目二期一工地发生坍塌，致1死1伤；7月2日，位于河南省安阳市中华路的碧桂园在建工地发生火灾；7月12日，杭州萧山碧桂园前宸府项目发生基坑坍塌；7月19日，河南省浙川碧桂园工地发生火灾。事故频发 是天灾还是人祸？碧桂园在针对六安项目事故的声明中指出，“事发时安徽六安城区降雨量达70毫米/小时，短时风速7级，特大暴雨和瞬时大风导致公司安徽六安项目一处围墙和项目红线外总包施工人员居住区活动板房发生坍塌。", 1533808228);
insert into post values (null, "涨停板复盘：沪指强势反弹涨1.83% 芯片概念掀涨停潮", "钱大妈", "新浪财经讯 8月9日消息，今日两市小幅低开后，一路震荡上行，沪指大涨近2%，一度站上2800点，创指大涨近4%，逼近1500点整数关口，A股呈现普涨行情，行业板块全线上涨，科技题材板块爆发，周期板块相对低迷，市场人气集聚回升，赚钱效应明显，截止收盘，沪指报2794.38点，涨1.83%，深成指报8752.20点，涨2.98%，创指报1497.61点，涨3.44%。一、涨跌停数据今日沪深涨停65家（涵盖新股及ST类），跌停8家，上涨个股3194只，下跌个股175只。二、热点板块国软软件全天领涨两市，板块个股悉数上涨，浪潮软件(18.570, 1.69, 10.01%)、中国软件(25.950,2.36, 10.00%)、润和软件(12.430, 1.13, 10.00%)涨停，宝信软件(26.300, 2.36, 9.86%)、卫士通(18.260, 1.38, 8.18%)、久其软件(9.480, 0.67, 7.60%)、用友网络(26.970, 1.93, 7.71%)湘邮科技(16.590, 1.00, 6.41%)、石基信息(33.550, 2.05, 6.51%)等个股均有大幅拉升。芯片概念股掀涨停潮，表现抢眼，必创科技(28.780, 2.62, 10.02%)、台基股份(14.390, 1.31, 10.02%)、北方华创(51.000, 4.42, 9.49%)、国科微(52.580, 4.78, 10.00%)、诚迈科技(24.970, 2.27, 10.00%)、友讯达(14.190, 1.29, 10.00%)、中兴通讯(14.300, 1.30, 10.00%)、兆日科技(8.920, 0.81, 9.99%)、亚翔集成(20.830, 1.89, 9.98%)等多股涨停。", 1533808228);
insert into post values (null,"php教程","习近平","PHP 是一种创建动态交互性站点的强有力的服务器端脚本语言。PHP 是免费的，并且使用非常广泛。同时，对于像微软 ASP 这样的竞争者来说，PHP 无疑是另一种高效率的选项。```php       foreach($data as $one){           foreach($one['items'] as $item){               $ffmpeg = \FFMpeg\FFMpeg::create(                   'timeout'          => 3600, // The timeout for the underlying process               ]);    $video = $ffmpeg->open($one['path']);               $format = new \FFMpeg\Format\Video\X264();               $path = basename($one['path']);               $size = $item['size'];               $kb = $item['kb'];               $format->on('progress', function ($video, $format, $percentage) use($path, $size, $kb){                   echo sprintf(\"%s %s %s %s\n\",$path, $size, $kb, $percentage);               });               $format->setAudioCodec('aac')                      ->setKiloBitrate($item['kb']);                      list($w, $h) = explode('x', $item['size']);               $filter = $video->filters()                               ->resize(new \FFMpeg\Coordinate\Dimension($w, $h));               $video->save($format, sprintf(\"/home/master/视频/%s-%s-%s码率.mp4\", $path, $size, $item['kb']));}}```mysql]创建数据库并指定编码",1533808228);


