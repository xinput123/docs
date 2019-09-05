## 问题
Mac版本升级到10.14后，在关闭的时候必然闪退. 因为sequel pro最近的一次版本是 1.1.2，已经是很久的版本了，所以我们需要自己拉代码重新编译构建

## 使用命令行编译即可
#### 1、下载源码
```
git clone https://github.com/sequelpro/sequelpro.git --depth=1
```

#### 2、将构建配置更改为Release
```
sed -i '' -e 's/Debug/Release/g' Makefile
```

#### 3、从ARCHS环境变量中删除i386（32位）
```
find . -type f -name "*.pbxproj" -exec sed -i '' -e 's/ARCHS_STANDARD_32_64_BIT/ARCHS_STANDARD_64_BIT/g' {} +
```

#### 4、构建
```
make
```

#### 5、构建成功后，从日志中找到Xcode编译好的文件位置。

#### 6、第四步直接构建时，有时候会出现问题
```
xcode-select: error: tool 'xcodebuild' requires Xcode, 
but active developer directory '/Library/Developer/CommandLineTools' 
is a command line tools instance
```

这种情况是xcodebuild的路径不正确。将路径切换到Xcode的目录下：

```
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer/
```

再重复步骤4