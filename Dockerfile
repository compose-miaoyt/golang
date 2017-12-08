FROM golang:1.9.2-alpine
# 修改apk源为aliyun源，alpine的命令安装方式为 apk add @software 
RUN set -xe \
    && cp /etc/apk/repositories /etc/apk/repositories.bak \
    && echo "http://mirrors.aliyun.com/alpine/v3.6/main/" > /etc/apk/repositories \
    && echo "http://mirrors.aliyun.com/alpine/v3.6/community/" >>/etc/apk/repositories \
    && apk update \
    && apk add bash vim 

# 安装ssh
RUN set -xe \
    && apk add openssh \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N "" \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_ecdsa_key -N "" \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_ed25519_key -N "" \
    && sed -i "/PermitRootLogin/d" /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
 
# 设置root密码
RUN set -xe \
    && apk add shadow  \
    && echo "root:123456" |chpasswd

# 程序使用的端口都要暴露出去，宿主机才能做端口映射，改了这里同时要在docker-compose.yml的 ports标签下加上
EXPOSE 22
EXPOSE 801

# 入口文件，docker需要ENTRYPOINT对应的进程存在才能存活，该进程挂掉容器就会退出
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh
