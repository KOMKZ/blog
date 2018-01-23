# InnoDB Locking

## Shared and Exclusive locks

InnoDB实现了标准的底层的两种锁，shared(S) locks 还有 exclusive(X) locks。
* shared(S) lock 允许持有该锁的事务能够读取加了该锁的数据行
* exclusive(X) lock 允许持有该锁的事务能够更新和删除该锁的数据行

如果事务T1持有了一个shared(S) lock在数据行r上，则如果存在其他不同的事务对该数据行请求加锁的处理规则如下：

* 事务T2在数据行上请求S锁能够立刻被授予，最终，事务T1和T2在数据行r上都持有该S锁
* 事务T2在数据行尚请求X锁不能够立即被授予

如果事务T1在数据行r上持有X锁，则来自其他事务在数据行r尚的加锁请求都不能被立刻授予，结果是，事务T2就必须等待事务T1释放了他在数据行r上的锁之后才能正常申请锁。

## Intention Locks

InnoDB支持多粒度锁控制使得行级锁和表级锁能够共存。为了使得控制锁的多粒度的程度能够被使用，将使用额外类型的锁，也就是所谓的intention locks, InnoDB中的intention locks是一种表级锁，表示一个事务接下来在该该表的数据行尚接下来想要请求哪种类型的锁(shared locks 还是 exclusive locks)，InnoDB中有两种类型的intention lock:

* intention shared: 代表事务T想要在数据表t中的个别行尚设置S锁
* intention exclusive: 代表事务T想要在一些行上设置X锁

(注：意向锁是一种意向，表明事务在该表的数据行上想要申请的锁，这种设计能够提高当前表是否存在某种行级锁的确定的效率，比如如果想对整个表进行申请写锁的话，应该先看看表是否有写锁，接着看所有的数据行是否有写锁，然后才能正常申请，而意向锁的功能立刻能够提高效率对于第二步操作。)

例如，`select ... lock in share mode` 设置了一个IS锁，`select ... for update` 设置了一个IX锁

intention lock拟定的规则如下：

* 事务T能够获取到表t中行r的S锁前，首先必须获取表t上一个IS锁或者更强的锁
* 事务T能够获取到表t中行r的X锁钱，首先必须获取表t上一个IX锁

这些规则能够简易的总结为下面这个表，锁类型兼容性矩阵表:

|      | *X*      | *IX*       | *S*        | *IS*       |
| ---- | -------- | ---------- | ---------- | ---------- |
| *X*  | Conflict | Conflict   | Conflict   | Conflict   |
| *IX* | Conflict | Compatible | Conflict   | Compatible |
| *S*  | Conflict | Conflict   | Compatible | Compatible |
| *IS* | Conflict | Compatible | Compatible | Compatible |

如果事务申请的锁能够和当前的锁相兼容的话，则能够被授予该锁，但如果和现有的锁冲突则不能被授予，只有等到当前正在冲突的锁被释放的时候才能被授予，如果申请一个锁发生冲突的话，且不能被授予的原因是因为死锁的原因，则会抛出一个错误。

注1：死锁是一种情况，发生在事务不能够被处理的时候，因为事务间都持有彼此需要的锁，彼此都在等待对方释放但是谁也不会释放，死循环，这是死锁的根本原因。

因此，intention locks不会阻塞住任何东西，除了对于表锁的申请的请求。（可以把横的看成申请的锁，竖的看成现有的锁），IX锁和IS锁的主要目地是告诉有人正在锁住表中的某行，或者准备锁住表中的某行。

事务的数据对于一个intention lock锁来看如下，可以使用`show engine innodb status`打印出来：

```
TABLE LOCK table `test`.`t` trx id 10080 lock mode IX
```

## Record Locks

行锁是一种作用在索引行上的锁，例如：`select c1 from t where c1 = 10 for update` 该语句能够防止其他事务插入，修改，删除 `t.c1 = 10` 这个条件的行。

行锁总是锁住索引行，即使表中没有任何的索引，这种情况下，InnoDB会创建一个隐藏的聚族索引，然后使用他作为行锁。

事务的数据对于一个intention lock锁来看如下，可以使用`show engine innodb status`打印出来：

```
RECORD LOCKS space id 58 page no 3 n bits 72 index `PRIMARY` of table `test`.`t` 
trx id 10078 lock_mode X locks rec but not gap
Record lock, heap no 2 PHYSICAL RECORD: n_fields 3; compact format; info bits 0
 0: len 4; hex 8000000a; asc     ;;
 1: len 6; hex 00000000274f; asc     'O;;
 2: len 7; hex b60000019d0110; asc        ;;
```

## Gap lock

Gap lock是一种锁住索引行范围（gap）的锁，或者锁住范围之外的锁（理解成为符合条件的范围），例如`select c1 from t where c1 between 10 and 20 for update` ,能够防止插入，更新，删除值为15的记录，不管这条记录是不是存在，因为符合这个范围的值都被锁住了。

这个锁定的范围可能占据着多个索引值，单个，或者是空。

