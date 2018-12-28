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

* because the lifetime of variable is determined only by whether or not it is reachable,有的时候如果函数内的变量通过某种方式返回，如指针等，则生存周期加长。

* x escapes from f, x must be heap-allocated because it is still reachable from the varible global after f has returned.

  ```
  var global *int
  func f(){
      var x int
      x = 1
      global = &x
  }
  ```

* when g returns, the variable *y becomes unreachable and can be recycled. so Its safe for the compiler to allocate *y on stack, even if it used by new.

  ```
  func g(){
      y := new(int)
      *y = 1
  }
  ```

* a compiler may choose to allcote local variable on he heap or stack, but result perhaps surprisingly, this choice is not determined by wheather var or new was used to declare the variable.

## Assignments

### tuple assignment 

* x, y = y, x
* often, functions use these additional result to indicate some kind of error, either by returning an error as in the call to os.Open, or a bool. and there 3 operators that behave this way too.
  * map key look up  -> v, ok = map[key]
  *  type assestion -> v, ok = x.(T)
  * channel receive -> v, ok = <-ch

### assignability

* there are many places ina program where an assigment occus implictly, eg,function call, return statement,a literal expression for a composite type.

  ```
  medals := []string{"abc", "cde"}
  // equals to 
  var medals []string{}
  medals[0] = "abc"
  medals[1] = "cde"
  ```

* more generally, the assigment is legal only if the value is assignable to the type of the variable.

## Type Declarations

* type name underlying-type

* even though both have the same underlying type, float64, they are not the same type, so they can not be compared or combined in arithmetic expression. and T(t) is coversion not a function call.and dont change the value or representation in any way.but make change of meaning explicit.

* for every type T, there is a coversion expression call T(t) to cover value of type to type t. the coversion from one type to another is allowed if both have the same underlying type, or if both have unamed pointer type that point to the same underlying type. so two value of different types can not be compared directly.

* coversion in numeric types , floating-point -> integer would disgard fractional part.

* type's method. new behaviours for values of type

  ```
  // Celsius is one kind of type
  func (c Celsius) String() string {return fmt.Sprintf("%g C", c)}
  ```

## Packages and Fils

### imports

* the language secification doesn't define where these strings come from or what they mean, its up to the tools to interpret them.
* by convertion, a package name matchs the last segment of its import path.

### package initialization

* package initialization begins by package-level variables in the order in which they are declare, but except that dependencies are resolved first.

  ```
  var a = b + c // thrid
  var b = f() // two
  var c = 1 // first
  ```

* any file may contains any number of functions whose declartions is just, 注意同个package的文件中可以多个init函数，执行顺序按照定义顺序来，同时init函数不能被调用和引用

* package的初始化按照导入顺序来，如果package中依赖了另一个package，则另一个package则先被初始化掉，根据他们的依赖来决定。所以main执行前，肯定都初始化好了。

## Scope

* the scope of declaration is a region of the program text

* lexical blocks 字面上的块，未必是由brace包含起来的

* universe block 全局块，作用于所有的内容

* a declaration lexical block determains its scope

  * the declarations of build-in types, functions and constatns are in the universe block and can be refer to thoughtout the entire program.
  * declaration outside the function, that is package-level, can be refered thoughout all files in the package.

* when the compiler encounters a reference to a name, it looks for a declaration, starting with innermost enclosing lexical block and working up to the univese block. maybe occurs undeclare name error.

* most blocks are created by control-flow constructs like if statements and for loops, 主意if和for, switch都会有自己的作用域，比如for一般loop body 和 brace包含起来的两个作用域loop body更加outer，

  ```
  func main()  {
  	x := "main" // block 1
  	for i, x := 0, "for_x!"; i < len(x); i++ { // block2
  		x := x[i] // block3
  		if x != '!' {
  			x := x // block4
  			fmt.Println(x)
  		}
  	}
  	fmt.Println(x)
  }
  if x:= f(); x == 0 {
      //
  }else if y:=g(x); x == y { // 这个scope更加深
      // 
  }
  ```

* 同级的block不能相互访问，只能访问outer的

* 注意作用域隐藏outer变量的问题，可能会发生的问题，变量没有正确赋值，变量没有使用的error

# Basic Data Type

* go types fall into four categories: basic types, aggregate types, reference types. and interface faces.

## integers

* int8,int16,int32,int64 and uint8, uint16, uint32, uint64
* the type rune is an synonym for int32 and indicates that a value is a unicode point
* the type byte is an synonym for uint8, that that a value is a piece of raw data rather than a small numeric quantity.
* 71页有运算符规则
* in go, the sign of the remainder is always the same as the sign of the dividend, so -5%3, -5%-3 are both -2, and 5.0/4.0 is 1.25 and 5/4 is 1,because integer division truncates the  result toward zero.
* overflow, 不够容纳，可能会导致原本是符号位的代码不能够正确的设置
* but a conversion that narows a big integer into a smaller one, or a conversion integer to floating-point to integer, may change the value or lose precision.

## floating-point numbers

* float32, float64,  math.MaxFloat32

* a float32 provides approximately siz decimal digits of precision. whereas a float64 provides about 15 digits.

* digits may be omitted before the dicimal point (.707) or after it (1.)

* math.IsNaN test whether its a argument is a not-a-number value. and math.NaN return such a value, any comparsion with NaN always yields false.

* if a function that returns a floating-point result but fail, its better to report the failure separately,

  ```golang
  func compute() (value float32, ok boolean){
      // ...
      if failed {
          return 0, false
      }
      return value, true
  }
  ```

## complex Numbers

todo

## booleans

* s[0] if index of 0 is not exist would panic.
* there is not implicit coversion from boolean to numberic like 0 or 1, or vice versa, 所以得自己定义方法，主意我们没有三目运算符

## strings

* the build-in len function return number of bytes (not rune) in a string, and attempting to access a byte outside the range results in panic.
* the + operator makes a new string by concatenaing two strings

### String Literals

* string value is a sequence of bytes enclosed in double quotes.
* a raw string literal is written ``, using backquotes instead of double quotes.within a raw sting literal, no esape sequences are processed;

## unicode 

* unicode version 8 defines code points for 120000 characters, and in go , the natural data type to hold a single rune is int32. it has the synonym rune for purpose.
* unicode优点：simple and uniform， but it uses much more space than ASCII。

## UTF-8

* utf8 is a variable-length encoding of unicode code points as bytes.

* the high-order bits of the first byte of the encoding for a rune indicates how many bytes follow.

  * a high-order 0 indicates 7-bit ASCII,where means 0 byte follows, and each rune takes one 1 byte.
  * a high-order 110 indicates that the rune takes 3 bytes, 2 bytes follow, and the others bytes begin with 10

* the unicode package provide funtions working with individual runes. and the unicode/utf8 package provides functions for encoding and decoding runes as bytes using utf8.

* there are two forms to make a value of unicode point. \uhhhh for 16-bit value and \Uhhhhhhhh for 32-bit value.一个16进字符需要用4位bit来表示， 

* 中文字符一般用3个字节24位来表示

* 以下表示等同

  ```
  "世界"
  "\xe4\xb8\x96\xe7\x95\x8c" // 每个一个字节
  "\u4e16\u754c" // 16-bit unicode转义表示法
  "\U00004e16\U0000754c" // 32-bit unicode
  ```

* a rune whose value is less than 256 may be written with a single hexadecimal escape.such '\x41' for 'A', 

  ,but for higher, a \u or \U escape must be used , \xe4\xb8\x96 is not a legal rune literal.

* strings.Contain

* 始终注意，len(string)返回的是字节数，不是字符数

  ```
  s := "hello, 世界"
  fmt.Println(len(s)) // 13
  fmt.Println(utf8.RuneCountInString(s)) //9
  ```

* 遍历utf字符有很多方法，下面介绍一种原始的解析方法：

  ```
  func main()  {
  	s := "hello, 世界"
  	for i, max := 0, len(s); i < max;{
  		r, size := utf8.DecodeRuneInString(s[i:])
  		fmt.Printf("%s %d %d\n", string(r), r, size)
  		i += size
  	}
  }func main()  {
  	s := "hello, 世界"
  	for i, max := 0, len(s); i < max;{
  		r, size := utf8.DecodeRuneInString(s[i:])
  		fmt.Printf("%s %d %d\n", string(r), r, size)
  		i += size
  	}
  }
  // 以下是输出
  h 104 1
  e 101 1
  l 108 1
  l 108 1
  o 111 1
  , 44 1
    32 1
  世 19990 3
  界 30028 3
  ```

* 上面的方法实际是clumsy，只要使用range就行，但是要主义，这里的i是一个字节的下标位置

  ```
  	for i, r := range s {
  		fmt.Printf("%s %d %d\n", string(r), r, i)
  	}
  ```

* each time utf8 decoder, wheather explit in a call to utf8.DecodeRuneInString or implict in a range loop, consumes a unexpected bytes, it would generate a special unicode point replacement character, \uffed.

* utf8在传输存储上有优势，但是在程序使用尚，unicode格式有优势，uniform size

* a []rune conversion applied to a utf8-encoded string return a sequence of unicode code points that the string encodes.

  ```
  s := "世界"
  r := []rune(s)
  //inserts a space between each pair of hex digits
  fmt.Printf("% x\n", s) //  e4 b8 96 e7 95 8c
  fmt.Printf("%x\n, r)//[4e16 754c]
  ```

















































































































