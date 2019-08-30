## hprof 
```
-- 每隔20ms采样CPU执行时间的信息，堆栈深度为3
java -agentlib:hprof=cpu=times,interval=20,depth=3 com.dsa.HprofSample

-- 采样堆内存信息
java -agentlib:hprof=heap=sites com.dsa.HprofSample

-- 查看hprof的帮助文档
java -agentlib:help com.dsa.HprofSample
```