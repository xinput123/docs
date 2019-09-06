IDEA 创建类文件的模板。

Editor -> File and Code Templates

```
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME};#end
#parse("File Header.java")
/**
 * @author <a href="mailto:xinput.xx@gmail.com">xinput</a>
 * @Date: ${YEAR}-${MONTH}-${DAY} ${TIME} 
 */
public class ${NAME} {
}
```