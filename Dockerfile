FROM centos:7
MAINTAINER Alan Peng <peng.alan@gmail.com>

ENV MAXSCALE_VERSION 1.4.3

RUN rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \
    && yum -y install https://downloads.mariadb.com/enterprise/yzsw-dthq/generate/10.0/mariadb-enterprise-repository.rpm \
    && yum -y update \
    && yum -y install maxscale-$MAXSCALE_VERSION \
    && yum -y install http://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-2.1.3-1.el7.x86_64.rpm \
    && yum -y install http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-utilities-1.6.4-1.el7.noarch.rpm \
    && yum clean all \
    && rm -rf /tmp/*

COPY maxscale.cnf /
COPY start-maxscale.sh /

# Move configuration file in directory for exports
RUN mkdir -p /etc/maxscale.d \
    && mv /maxscale.cnf /etc/maxscale.d/maxscale.cnf \
    && ln -sf /etc/maxscale.d/maxscale.cnf /etc/maxscale.cnf

# VOLUME for custom configuration
VOLUME ["/etc/maxscale.d"]

# EXPOSE the MaxScale default ports

## RW Split Listener
EXPOSE 4006

## Read Connection Listener
EXPOSE 4008

## Debug Listener
EXPOSE 4442

## CLI Listener
EXPOSE 6603

# Running MaxScale
ENTRYPOINT ["/start-maxscale.sh"]
