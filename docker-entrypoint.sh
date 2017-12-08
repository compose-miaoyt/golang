#!/bin/bash

#启动go程序示例
#mkdir -p /root/work/logs/
#nohup go run test.go &>/root/work/logs/test.log & 

# 启动ssh,非守护进程用于保持容器不退出，其他命了需要加在前面且需要后台运行
/usr/sbin/sshd -D
