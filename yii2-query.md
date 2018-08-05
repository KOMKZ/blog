# 基于Yii2的Query层封装

## 职责

如下说明：

1. 封装业务中所有可能的query，注意返回一定是 `ActiveQuery`
2. 组装扩展字段到主体字段中，方便使用
3. 允许定义需要哪些扩展字段集，最终实现组装

## 封装要素

如下说明:

1. 如果查询中需要发生联表，务必要对表重新命名， 同时必须有相关注释
2. 表字段被垂直分割时，需要有参数能够支持选定指定的字段
3. 如果一个实体管理的实体依旧存在者多级关联，能够通过字段继续定义关联。

## 方法示例

**假设存在如下实体：**

```
user: 用户主信息
- u_id 用户id
- u_name 用户姓名

user_detail：用户详细信息
- u_id 用户id
- u_long_intro 用户详细介绍

user_skills: 用户技能树
- u_id 用户id
- skill_id 技能id

skill: 技能介绍
- skill_id 技能id
- skill_name 技能名称
- skill_hot_value 技能热值
```

**各个实体的关系如下：**

```
user(1.u_id-1.u_id)user_detail
user(1.u_id-n.u_id)user_skills

user_detail(1.u_id-1.u_id)user

user_skills(n.u_id-1.u_id)user
user_skills(1.skill_id-1.skill_id)skill

skill(n.sku_id-n.sku_id)user_skills
```

上述实体的关系中，我们省略掉部分不明显的关系如`user_skills()user_detail`, 这是因为从实际的场景中出发这种查询一般不太常见，所以忽略，我们更多关注的是从实体`user`出发或者是从实体`user_skills`出发，但是需要注意的是，当从实体`user_skills`出发的时候我们可能需要获取完整的`user`实体信息，但是也可能不需要。

**则对于实体`user` 我们存在以下的使用场景：**

1. 查询实体`user` 的信息包括如下：

```
- u_id 用户id
- u_name 用户姓名
- u_long_intro 用户详细介绍 (来源于实体u_detail)
- u_skills
	- 0 
        - skill_name 技能名称 (来源于实体skill)
        - skill_id 技能id (来源于实体u_skills)
		- skill_hot_value 技能热值 (来源于实体skill)
```

1. 查询实体`user`的信息部分如下,需求表现为全部定制化字段

```
- u_id 用户id
- u_long_intro 用户详细介绍 (来源于实体u_detail)
- u_skills
	- 0 
        - skill_name 技能名称 (来源于实体u_skills)
```

或者

```
- u_id 用户id
- u_name 用户姓名
- u_long_intro 用户详细介绍 (来源于实体u_detail)
```

**对于上述场景我们进行以下方法定义：**

```

```

**通过上述可能的方法，总结定义实体的`QueryModel`有如下需求：**

**实体表定义如下：**

```
SET foreign_key_checks = 0;
```

实体定义如下：

```sql
drop table if exists `user`;
create table `user`(
`u_id` int(10) unsigned not null auto_increment comment '主键',
`u_name` varchar(64) not null comment '用户名称',
primary key (`u_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;

drop table if exists `user_detail`;
create table `user_detail`(
`ud_id` int(10) unsigned not null auto_increment comment '主键',
`u_id` int(10) unsigned not null comment '用户id',
`ud_long_intro` text not null comment '用户长介绍',
primary key (`ud_id`),
foreign key (`u_id`) references `user` (`u_id`),
unique key (`u_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;

drop table if exists `user_skills`;
create table `user_skills`(
`us_id` int(10) unsigned not null auto_increment comment '主键',
`u_id` int(10) unsigned not null comment '用户id',
`sk_id` int(10) unsigned not null comment '技能id',
primary key (`us_id`),
foreign key (`u_id`) references `user` (`u_id`),
foreign key (`sk_id`) references `skill` (`sk_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;

drop table if exists `skill`;
create table `skill`(
`sk_id` int(10) unsigned not null auto_increment comment '主键',
`sk_name` varchar(64) not null comment '技能名称',
primary key (`sk_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;

drop table if exists `skill_tag`;
create table `skill_tag`(
skt_id int(10) unsigned not null auto_increment comment '主键',
sk_id int(10) unsigned not null comment '实体',
skt_name varchar(64) not null comment '标签名称',
primary key (`skt_id`),
foreign key (`sk_id`) references `skill` (`sk_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;

insert into skill values (1, 'php');
insert into skill values (2, 'golang');
insert into skill values (3, 'sql');
insert into user values (1, 'kitral');
insert into user values (2, 'lartik');
insert into user_detail values (1, 1, 'kitral is a phper');
insert into user_detail values (2, 2, 'lartik is golang enginer');
insert into user_skills values (1, 1, 1);
insert into user_skills values (2, 1, 3);
insert into user_skills values (3, 2, 2);
insert into user_skills values (4, 2, 3);
insert into skill_tag values (1, 1, 'yii2');
insert into skill_tag values (2, 1, 'larvel');
insert into skill_tag values (3, 2, 'channel');
insert into skill_tag values (4, 2, 'beego');
```
