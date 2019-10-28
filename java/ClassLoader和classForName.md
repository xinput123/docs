## 类装载过程
```
装载：通过累的全限定名获取二进制字节流，将二进制字节流转换成方法区中的运行时数据结构，在内存中生成Java.lang.class对象； 

链接：执行下面的校验、准备和解析步骤，其中解析步骤是可以选择的； 

　　校验：检查导入类或接口的二进制数据的正确性；（文件格式验证，元数据验证，字节码验证，符号引用验证） 

　　准备：给类的静态变量分配并初始化存储空间； 

　　解析：将常量池中的符号引用转成直接引用； 

初始化：激活类的静态变量的初始化Java代码和静态Java代码块，并初始化程序员设置的变量值。
```

## 解释
在java中Class.forName()和ClassLoader都可以对类进行加载。ClassLoader就是遵循双亲委派模型最终调用启动类加载器的类加载器，实现的功能是"通过一个类的全限定名来获取描述此类的二进制字节流"，获取到二进制流后放到JVM中。Class.forName()方法实际上也是调用的CLassLoader来实现的。

Class.forName(String className)；这个方法的源码是

```
@CallerSensitive
public static Class<?> forName(String className)
            throws ClassNotFoundException {
    Class<?> caller = Reflection.getCallerClass();
    return forName0(className, true, ClassLoader.getClassLoader(caller), caller);
}
```

最后调用的方法是forName0这个方法，在这个forName0方法中的第二个参数被设置为了true，这个参数代表是否对加载的类进行初始化，设置为true时会对类进行初始化，代表会执行类中的静态代码块，以及对静态变量的赋值操作。

也可以调用Class.forName(String name, boolean initialize, ClassLoader loader) 方法来手动选择在加载类的时候是佛要对类进行初始化。Class.forName(String name, boolean initialize, ClassLoader loader) 的源码如下：

```
    /**
     * @param name       fully qualified name of the desired class
     * @param initialize if {@code true} the class will be initialized.
     *                   See Section 12.4 of <em>The Java Language Specification</em>.
     * @param loader     class loader from which the class must be loaded
     * @return           class object representing the desired class
     *
     * @exception LinkageError if the linkage fails
     * @exception ExceptionInInitializerError if the initialization provoked
     *            by this method fails
     * @exception ClassNotFoundException if the class cannot be located by
     *            the specified class loader
     *
     * @see       java.lang.Class#forName(String)
     * @see       java.lang.ClassLoader
     * @since     1.2
     */
     
@CallerSensitive
public static Class<?> forName(String name, boolean initialize,  ClassLoader loader)
    throws ClassNotFoundException
{
    Class<?> caller = null;
    SecurityManager sm = System.getSecurityManager();
    if (sm != null) {
        // Reflective call to get caller class is only needed if a security manager
        // is present.  Avoid the overhead of making this call otherwise.
        caller = Reflection.getCallerClass();
        if (sun.misc.VM.isSystemDomainLoader(loader)) {
            ClassLoader ccl = ClassLoader.getClassLoader(caller);
            if (!sun.misc.VM.isSystemDomainLoader(ccl)) {
                sm.checkPermission(
                    SecurityConstants.GET_CLASSLOADER_PERMISSION);
            }
        }
    }
    return forName0(name, initialize, loader, caller);
}
```

其中对参数initialize的描述是：if {@code true} the class will be initialized.意思就是说：如果参数为true，则加载的类将会被初始化。


## 举例
```
package com.cls;

/**
 * @author <a href="mailto:xinput.xx@gmail.com">xinput</a>
 * @Date: 2019-09-25 10:58
 */
public class ClassForName {

    //静态代码块
    static {
        System.out.println("执行了静态代码块");
    }
    //静态变量
    private static String staticFiled = staticMethod();

    //赋值静态变量的静态方法
    public static String staticMethod(){
        System.out.println("执行了静态方法");
        return "给静态字段赋值了";
    }

}
```

```
public class MyTest {
    @Test
    public void test44(){

        try {
            Class.forName("com.test.mytest.ClassForName");
            System.out.println("#########分割符(上面是Class.forName的加载过程，下面是ClassLoader的加载过程)##########");
            ClassLoader.getSystemClassLoader().loadClass("com.test.mytest.ClassForName");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

    }
}
```

##### 运行结果
```
测试 Class.forName
执行了静态代码块
执行了静态方法
================
测试ClassLoader
```

## 应用场景
在我们熟悉的Spring框架中的IOC的实现就是使用的ClassLoader。而在我们使用JDBC时通常是使用Class.forName()方法来加载数据库连接驱动。这是因为在JDBC规范中明确要求Driver类必须向DriverManager注册自己。以Mysql驱动为例解释

```
public class Driver extends NonRegisteringDriver implements java.sql.Driver {  
    // ~ Static fields/initializers  
    // ---------------------------------------------  
  
    //  
    // Register ourselves with the DriverManager  
    //  
    static {  
        try {  
            java.sql.DriverManager.registerDriver(new Driver());  
        } catch (SQLException E) {  
            throw new RuntimeException("Can't register driver!");  
        }  
    }  
  
    // ~ Constructors  
    // -----------------------------------------------------------  
  
    /** 
     * Construct a new driver and register it with DriverManager 
     *  
     * @throws SQLException 
     *             if a database error occurs. 
     */  
    public Driver() throws SQLException {  
        // Required for Class.forName().newInstance()  
    }  
}
```

我们看到Driver注册到DriverManager中的操作写在了静态代码块中，这就是为什么在写JDBC时使用Class.forName()的原因了。