# Source docker image to be used
FROM sloopstash/amazon-linux-2:v1.1.1

#Install system dependencies and packages required for Redis database server
RUN yum install -y tcl 

# Download and extract Redis from source code   
WORKDIR /tmp

RUN set -x \
    && wget http://download.redis.io/releases/redis-7.2.1.tar.gz --quiet \
    && tar xzvf redis-7.2.1.tar.gz > /dev/null 

# Compile and install Redis from source code
WORKDIR /tmp/redis-7.2.1
RUN set -x \
    && make distclean \
    && make \
    && make install

# Create required directories and run Redis database server
RUN set -x \
    && rm -rf /tmp/redis-* \
    && mkdir /opt/redis \
    && mkdir /opt/redis/data \
    && mkdir /opt/redis/logs \
    && mkdir /opt/redis/conf \
    && mkdir /opt/redis/script \
    && mkdir /opt/redis/system \
    && touch /opt/redis/system/server.pid \
    && touch /opt/redis/system/supervisor.ini \
    && history -c