## 1、运行脚本
```
wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh

chmod +x shadowsocks-all.sh

./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log
```

![image.png](https://upload-images.jianshu.io/upload_images/4046640-6f85567f0755f190.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 2、我选择的是 Shadowsocks-Go。
输入3，然后输入密码和端口。
```
ou choose = Shadowsocks-Go

Please enter password for Shadowsocks-Go
(default password: teddysun.com):

password = teddysun.com

Please enter a port for Shadowsocks-Go [1-65535]
(default port: 8989):

port = 8989

Press any key to start...or Press Ctrl+C to cancel
```

## 3、安装成功后，命令行出现刚刚输入的参数
