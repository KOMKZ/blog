# The Go Programming language

# Tutorial

## Hello world

* go 的子命令run,读取*.go文件,从原文件从编译起来,将他们跟库文件链接起来,然后最终生成可执行文件,然后执行.
* go build 可以构建文件,然后生成执行文件,方便以后使用,在当前目录生成
* go code is organized into package
* go natively handles Unicodes
* package main is speical, it difeins a standlong executable program, not a libray, and within main package main the function is also special, where execution of the program begins.
* the import declartions must follow the package declartion.
* go does not require semicolons at the ends of statement or declartions. in effect, newlines following centain tokens are covert to semicolons, 所以这里有个需要注意的地方,比如the opening brace { of the function must on the same line as the end of fun declation, not on a line by itself.
* go tools gofmt rewrite code into standard format. and fmt subcommand applies gofmt to all file in the speciafied package.( think of configruations of editor.)
* goimports would manages the insertion and removal of import declartion as needed.

## Command-Line Arguments

* command-line arguments => os.Args, which is a slice of string, 

* the number of elements in slice given by len(s)

* s[m:n] use half-open intervals the include the m index but exclude the n index.

* os.Args[0] is the name of command-line itself.

* if m or n is omitted, it defaults to 0 or len(s) respectively.

* by convention, we describe each package in a comment immediately preceding its package declation.

* if it is not emplicitly initialized, it is implicitly initialized to zero value for its type, which is 0 to numberic types and the empty string for strings.

* the + operator concatnates the values, which also used in string type

* 可以使用 := 来声明变量,同时根据初值来初始化合理的变量类型.

* i++ is statement, not expression, so j = i++ or j = --i are illegal both.

* parenthess are nerver used around the three components of loop, and of componens of loop can be omitted,

  ```
  // a traditional while loop
   for condition {
       
   }
  // a traditionl infinate loop
  for {
  }
  ```

* use blank identifier 用于占位,时间改变量可以不使用

  ```
  func main() {
  	s, sep := "", " "
  	for _, val := range os.Args[1:] {
  		s += sep + val
  	}
  	fmt.Println(s)
  }
  ```

* strings.Join(os.Args[1:], " ")

## Finding Duplicate LInes

* a map holes a set of key/value pairs, the keys may be of ay type whose can compared with ==

* m = m[k] + 1, k建可以不存在,这样右边的m[k]会先有个初始值

* the order of map iteration is not specified, always in priactice it is random.

* bufio package make input and output efficient and convenient.

  ```
  input := bufio.NewScanner(os.Stdin)
  input.Scan()
  input.Text()
  ```

  input.Scan() reads the next line and remove the newline character from the end.and the content can be retrived by input.Text(), the Scan function return a true if there is a line and false wher there is no more input.

* os.Open的使用

  ```
  f, err := os.Open(path)
  if err != nil { // }
  // 可以使用 bufio 来使用
  f.Close()
  ```

* Fprintf, 写入这些信息及入文件handler中

* a map is a reference to the data structure created by make , 函数内对她的修改在函数外面依旧会发生改变

* 除了(*Scanner).Scan()读取内容的方法, 对于文件来说还有 ioutil.ReadFile的方法

  ```
  data, err := ioutil.ReadFile(path)
  if err != nil {}
  // take care data is byte type
  strings.Split(string(data), "\n")
  ```

## animated Gifs

* after importing a pcakge whose path has multiple components, we refer the package with a nem that comes form the last component., like the image.color

* like var declation, const declation could be appear at package level, so the name are visable throughtout the package . or within the function ( so the names are visable only function )

* composite literals, []color.Color{}, git.GIF{},

  ```
  var patt = []color.Color{color.White, color.Black}
  // a slice with two elements, first is color.White, second is color.Black
  var g = gif.GIF{nframe: narger}
  ```

## Fetch a Url

* http的简单使用

  ```
  	for _, url := range os.Args[1:] {
  		res, err := http.Get(url)
  		if err != nil {
  			fmt.Fprintf(os.Stderr, "fetch: %v\n", err)
  			continue
  		}
  		data, err := ioutil.ReadAll(res.Body)
  		if err != nil {
  			fmt.Fprintf(os.Stderr, "fetch: %v\n", err)
  			continue
  		}
  		res.Body.Close()
  		fmt.Printf("%s", data)
  	}
  ```

## fetching urls concurencyly

* create a channel use make `ch := make(chan string)`
* the go statement create a new routine for call to fetch function, 这样就能够实现异步调用

```
package main

import (
	"time"
	"fmt"
	"os"
	"net/http"
	"io"
	"io/ioutil"
)

func main() {
	start := time.Now()
	ch := make(chan string)
	for _, url := range os.Args[1:] {
		go fetch(url, ch)
	}
	for range os.Args[1:] {
		fmt.Printf("%v", <-ch)
	}
	fmt.Printf("%0.2fs elapsed\n", time.Since(start).Seconds())
}

func fetch(url string, ch chan<- string){
	start := time.Now()
	res, err := http.Get(url)
	if err != nil {
		ch <- fmt.Sprintf("%v\n", err)
		return
	}
	nbytes, err := io.Copy(ioutil.Discard, res.Body)
	if err != nil{
		ch <- fmt.Sprintf("%v\n", err)
		return
	}

	ch <- fmt.Sprintf("%0.2f %s %d bytes\n", time.Since(start).Seconds(), url, nbytes)
}

```

## a web server

todo

##a loose ends

todo

# the program struct

## Names

* Case matters, heapSort and HeapSort are different names.
* go has 25 keywords can not be used as names, and about three dozen predecleared names like uint are not reserved, you can see the list in page 47.
* if variables declared outside the function, it is visable in all files of the package to which it belongs,
* if the name begin with the upper-case letter, it is exported.
* package names thenselves are always lower case.
* use camel case formating, so parsetRequestLine is good, dont use parse_request_line, and the letters of acronyms and initialisam are always render in same case, so escapeHTML or htmlEscape is goods, but not use escapeHtml.

## declartions

* the package declartions is followed by any import declartions.
* the major declartion types are : var, const, type, func
* package level vs local level

## Variables

* var name type = expression

* either the type or = expression can be obmitted, but not both. if the type is obmitted, its type is determined by initializer expression, and the expression is obmitted, the initial value is the zero value for the type. 0 for numbers, false for boolean, '"" for strings, nil for interfance and reference (slice, map, pointer, function, channel), and the zero value of and aggregate type like struct has the zero value of its elements of fields. 总之go会保证初始值的存在.

* declare multiple variables as one type 

  ```
  var a, b, c int;
  a, b = "abc", 1 // compile error, because a is int type, cant assigned string value
  ```

* declare variables of different types with initrilized value

  ```
  var a, b, c = 1, false, "h"
  ```

* 也可以使用函数的返回值进行declare

  ```
  var f, err = os.Open(path)
  ```

### Short Variable Declarations

* with a function, form called short variable declaration can be used alternatly. 

  ```
  a, b := 2, 3
  ```

* only for local variables

* you also can use var declaration within a function, but var declaration tends to be reserved  for local variables the need explict type or initial value is not important.

* keep in mind := is declaration, but not a assigment.

* a short declaration must declare at least one new variable, others old declared variables acted as like assigment.

  ```
  in, err := os.Open(path) 
  // ...
  // at least one new variable
  // and action at err is assigment but not declaration this time
  out, err := os.Open(path) 
  						  
  ```

### Pointers

* a pointer value is address of variable, not every value has an address, but every variable does.

* var x int, => &x ( address of x) => p = &x ( p point to x, or p contains address of x ) => *p yields the value of variable => *p = 3 is ok

* 聚合类型struct的元素或者array的元素都有一个地址

* the zero value for a pointer of any type is nil, pointers are comparable, two pointers are equal if they point to the same variable or both are nil.

* var a int, &a 是一个地址，但是这个地址可能不是nil，nil的情况是 var a *int 此时地址类型的初始值都是nil

* pointers are key to the flag package

* flag包的一个简单使用：

  ```
  var s = flag.String("s", " ", "seperator")
  flag.Parse()
  fmt.Print(strings.Join(flag.Args()), *s))
  ```

### the new function

* another way to create a variable is to use the build-in function new, the expression new(T) creates an unnamed variabled of type T, initialized it to the zero value of T, and return its address, that is *T
* 没有什么区别一般是在变量不怎么需要用到名字的时候可以考虑这个方法，这是一个动态创建类型的方法
* 注意struct和[0]
* new 不是关键字，所以可以用于命名，但是会覆盖掉new这个function

### lifetime of variables

* the lifetime of a variable is the interval of time during which it exists as the  program executes.
* the lifetime of package-level variable is the entire execution of the program.
* 本地变量的话的生存周期比较动态，比如函数的参数和返回结果在调用结束之后就会被回收,
* go的垃圾回收是怎么知道一个变量可以被回收了呢?todo
* because the lifetime of variable is determined only by whether or not it is reachable,




















































































































