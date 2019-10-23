#!/bin/bash

## redis主机IP
host=$1

## redis主机port
port=$2

## key模式
pattern=$3

## 游标
cursor=0

## 退出信号
signal=0

## 循环获取key并删除
while [ $signal -ne 1 ]
	do
		echo "cursor:${cursor}"
		sleep 2
		## 将redis scan得到的结果赋值到新标量
		re=$(redis-cli -h $host -p $port -c scan $cursor count 1000 match $pattern)
		## 以换行作为分隔符
		IFS=$'\n'
		## echo $re
        echo 'arr=>'
        ## 转成数组
        arr=($re)
        ## 打印数组长度
        echo 'len:'${#arr[@]}
        ## 第一个元素是游标值
        cursor=${arr[0]}
        ## 游标为0表示没有key了
        if [ $cursor -eq 0 ];then
            signal=1
        fi
        
    ## 循环数组
    for key in ${arr[@]}
        do
            echo $key
            if [ $key != $cursor ];then
                echo "key:"$key
                ## 删除key
                redis-cli -h $host -p $port -c del $key >/dev/null  2>&1
            fi
    done
done
echo 'done'