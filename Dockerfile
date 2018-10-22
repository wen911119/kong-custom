FROM registry.docker-cn.com/library/kong:latest
ENV TZ="Asia/Shanghai"
ADD plugins /opt/plugins
ADD kong.conf /etc/kong/kong.conf