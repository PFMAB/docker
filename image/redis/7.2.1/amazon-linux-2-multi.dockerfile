##########BEGIN STAGE###########
# In this stage, we are installing system packages required for Redis database server

FROM sloopstash/amazon-linux-2:v1.1.1 AS install_system_packages

#Install system dependencies and packages required for Redis database server
RUN yum install -y tcl

############END STAGE#############

##########BEGIN STAGE#############
# In this stage, we are downloading, extracting, compiling and installing Redis database server from source code
FROM install_system_packages AS redis_install
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

#########END STAGE#################

##########BEGIN STAGE###########
# In this stage, we are creating required directories and files for Redis database server
FROM sloopstash/amazon-linux-2:v1.1.1 AS create_redis_directories

# Create required directories and run Redis database server
RUN set -x \
    && mkdir /opt/redis \
    && mkdir /opt/redis/data \
    && mkdir /opt/redis/logs \
    && mkdir /opt/redis/conf \
    && mkdir /opt/redis/script \
    && mkdir /opt/redis/system \
    && touch /opt/redis/system/server.pid \
    && touch /opt/redis/system/supervisor.ini \
    && history -c

###############END STAGE#############

#############BEGIN STAGE##############
# In this stage, we are copying the required binary and directories and creating the final resultant Redis OCI image
FROM sloopstash/amazon-linux-2:v1.1.1 AS resultant_redis_oci_image

#Copy redis binary executable program
COPY --from=redis_install /usr/local/bin/redis-server /usr/local/bin/redis-server

#Copy Redis directory
COPY --from=create_redis_directories /opt/redis /opt/redis

################END STAGE################s