## 示例

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

2. 查询实体`user`的信息部分如下,需求表现为全部定制化字段

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

`user`实体:

```sql
drop table if exists `user`;
create table `user`(
`u_id` int(10) unsigned not null auto_increment comment '主键',
`u_name` varchar(64) not null comment '用户名称',
primary key (`u_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;
```

`user_detail` 实体：

```
drop table if exists `user_detail`;
create table `user_detail`(
`ud_id` int(10) unsigned not null auto_increment comment '主键',
`ud_u_id` int(10) unsigned not null comment '用户id',
`ud_long_intro` text not null comment '用户长介绍',
primary key (`ud_id`),
foreign key (`ud_u_id`) references `user` (`u_id`),
unique key (`ud_u_id`)
)CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE=InnoDB;
```



