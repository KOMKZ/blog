# git commit 信息

commit格式：

```
<type>(<scope>): <subject>
// 空一行
(body)
// 空一行
(footer)
```

注意：

1. 其中，Header 是必需的，Body 和 Footer 可以省略。

2. 不管是哪一个部分，任何一行都不得超过72个字符（或100个字符）。这是为了避免自动换行影响美观。

3. 括号代表可选，尖括号代表必选

4. type的类型如下：（便于快速过滤，方法todo）

   1. feat：新功能（feature）
   2. fix：修补bug
   3. docs：文档（documentation）
   4. style： 格式（不影响代码运行的变动）
   5. refactor：重构（即不是新增功能，也不是修改bug的代码变动）
   6. test：增加测试
   7. chore：构建过程或辅助工具的变动

5. scope用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

6. body可以多行，用于描述详细信息

7. footer

   1. **不兼容变动**

      如果当前代码与上一个版本不兼容，则 Footer 部分以`BREAKING CHANGE`开头，后面是对变动的描述、以及变动理由和迁移方法。

   2. **关闭 Issue**

      如果当前 commit 针对某个issue，那么可以在 Footer 部分关闭这个 issue 。

8. 用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

9. `scope`用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

10. `scope`用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

11. `scope`用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

12. `scope`用于说明 commit 影响的范围，比如数据层、控制层、视图层等等，视项目不同而不同。

eg:

```

```

