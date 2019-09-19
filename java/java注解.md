## 一、元注解
### @Retention 指明修饰的注解的生存周期，即会保留到哪个阶段。
- **SOURCE** : 源码级别保留，编译后即丢弃。
- **CLASS** : 编译级别保留，编译后的class文件中存在，在jvm运行时丢弃，这是默认值。
- **RUNTIME** : 运行级别保留，编译后的class文件中存在，在jvm运行时保留，可以被反射调用。


### @Target  用于设定注解使用范围
- **TYPE** : 表明此注解可以用在类或接口上
- **FIELD** : 表明此注解可以用在域上
- **METHOD** : 表明此注解可以用在方法上
- **PARAMETER** : 表明此注解可以用在参数上
- **CONSTRUCTOR** : 表明此注解可以用在构造方法上
- **LOCAL_VARIABLE** : 表明此注解可以用在局部变量上
- **ANNOTATION_TYPE** : 表明此注解可以用在注解类型上
- **PACKAGE** : 用于记录java文件的package文件信息，
- **TYPE_PARAMETER** : 类型参数声明
- **TYPE_USE** : 类型使用声明 


## 二、普通注解