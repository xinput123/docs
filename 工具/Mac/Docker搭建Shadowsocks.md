```
docker run -d -p 1984:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k Yuan,.?@ -m aes-256-cfb
```

> - -d 参数允许docker常驻后台运行
> - -p 指定要映射的端口，这里端口号统一即可
> - -s 服务器IP地址，不用动
> - -k 后面设置VPN的密码
> - -m 指定加密方式