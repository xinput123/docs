## 示例
配置如下

```
-XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:D:/gc.log
```

### YongGC
```
2019-04-18T14:52:06.790+0800: 2.653: [GC (Allocation Failure) [PSYoungGen: 33280K->5113K(38400K)] 33280K->5848K(125952K), 0.0095764 secs] [Times: user=0.00 sys=0.00, real=0.01 secs]
```

含义

- 2019-04-18T14:52:06.790+0800（当前时间戳）: 

- 2.653（应用启动基准时间）: 

- [GC (Allocation Failure) [PSYoungGen（表示 Young GC）: 33280K（年轻代回收前大小）->5113K（年轻代回收后大小）(38400K（年轻代总大小）)] 33280K（整个堆回收前大小）->5848K（整个堆回收后大小）(125952K（堆总大小）), 0.0095764（耗时） secs] 

- [Times: user=0.00（用户耗时） sys=0.00（系统耗时）, real=0.01（实际耗时） secs]

### FULL GC
```
2019-04-18T14:52:15.359+0800: 11.222: [Full GC (Metadata GC Threshold) [PSYoungGen: 6129K->0K(143360K)] [ParOldGen: 13088K->13236K(55808K)] 19218K->13236K(199168K), [Metaspace: 20856K->20856K(1069056K)], 0.1216713 secs] [Times: user=0.44 sys=0.02, real=0.12 secs]
```

含义

- 2019-04-18T14:52:15.359+0800（当前时间戳）: 

- 11.222（应用启动基准时间）: 

- [Full GC (Metadata GC Threshold) [PSYoungGen: 6129K（年轻代回收前大小）->0K（年轻代回收后大小）(143360K（年轻代总大小）)] 

- [ParOldGen: 13088K（老年代回收前大小）->13236K（老年代回收后大小）(55808K（老年代总大小）)] 19218K（整个堆回收前大小）->13236K（整个堆回收后大小）(199168K（堆总大小）), [Metaspace: 20856K（持久代回收前大小）->20856K（持久代回收后大小）(1069056K（持久代总大小）)], 0.1216713（耗时） secs] 

- [Times: user=0.44（用户耗时） sys=0.02（系统耗时）, real=0.12（实际耗时） secs]