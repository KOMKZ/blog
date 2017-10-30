**webpack + babel 进行es6实验**

说明：

1. 各个项目的依赖各自管理，所以我们这里的安装包都不是全局安装。

webpack安装：

```a
$ mkdir w-b-js
$ cd w-b-js
$ npm init
$ npm install webpack --save-dev
```



babel安装：

```
# 安装加载器 babel-loader 和 Babel 的 API 代码 babel-core
$ npm install --save-dev babel-loader babel-core
# 安装 ES2015（ES6）的代码，用于转码
$ npm install babel-preset-es2015 --save-dev
# 用于转换一些 ES6 的新 API，如 Generator，Promise 等
$ npm install --save babel-polyfill
```



webpack配置，在根目录新建`webpack.config.js`：

```
module.exports = {
    entry: [
        "babel-polyfill",
        "./index.js"
    ],
    output: {
        path: __dirname + '/output/',
        publicPath: "/output/",
        filename: 'index.js'
    },
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                exclude: /(node_modules|bower_components)/,
                loader: 'babel-loader', // 'babel-loader' is also a legal name to reference
                query: {
                    presets: ['es2015']
                }
            }
        ]
    }
};
```



新建目录src，放你的测试代码：

```
$ mkdir src
$ vim index.js
```



运行：

- `webpack`——直接启动 webpack，默认配置文件为 `webpack.config.js`
- `webpack -w`——监测启动 webpack，实时打包更新文件
- `webpack -p`——对打包后的文件进行压缩

