# 指定ubuntu镜像
FROM ubuntu:focal

# -e:跑的过程中遇到错误就退出, -x是跑的过程中执行的命令和输出都打印出来
RUN set -ex; \
    groupadd --gid 999 --system mysql; \
    useradd \
    --uid 999 \
    --system \
    --home-dir /var/lib/mysql \
    --no-create-home \
    --gid mysql \
    mysql; \
    # replace the source list.
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list; \
    echo "# deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "# deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "# deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    echo "#deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list; \
    apt-get update; \
    # 这里是安装公钥需要的一些软件
    if ! which gpg; then \
        apt-get install -y --no-install-recommends gnupg; \
    fi; \
    if ! gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
        apt-get install -y --no-install-recommends dirmngr; \
    fi; \
    # 把更新和安装过程中残留的东西给清除了。
    rm -rf /var/lib/apt/lists/*

    # 定义环境变量,指定mysql版本号 
ENV PS_VERSION 5.7.33-36-1
ENV OS_VER focal
ENV FULL_PERCONA_VERSION "$PS_VERSION.$OS_VER"

RUN set -ex; \
    # 添加公钥,不然添加不进去,然后添加percona软件源
    key='9334A25F8507EFA5'; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver keys.gnupg.net --recv-keys "$key"; \
    gpg --batch --export $key > /etc/apt/trusted.gpg.d/mysql.gpg; \
    command -v gpgconf > /dev/null && gpgconf --kill all || :; \
    rm -r "$GNUPGHOME"; \
    apt-key list > /dev/null; \
    echo "deb http://repo.percona.com/apt focal main\ndeb-src http://repo.percona.com/apt focal main">> /etc/apt/sources.list.d/mysql.list; \
    # 再更新一遍
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true; \
    { \
	# 先填好密码，为了静默安装，后面安装mysql就不需要输入密码，默认是空
        echo percona-server-server-5.7=${FULL_PERCONA_VERSION} percona-server-server-5.7=${FULL_PERCONA_VERSION}/root-pass password ''; \
        echo percona-server-server-5.7=${FULL_PERCONA_VERSION} percona-server-server-5.7=${FULL_PERCONA_VERSION}/re-root-pass password ''; \
	# 设置时区信息：亚洲上海，东八区
        echo tzdata tzdata/Areas select Asia; \
        echo tzdata tzdata/Zones/Asia select Shanghai; \
    } | debconf-set-selections; \
    # install "tzdata" for /usr/share/zoneinfo/
    # 安装依赖, 时区，server,common,tokudb
    apt-get install -y --no-install-recommends libjemalloc1 libmecab2 tzdata; \
    apt-get install -y --no-install-recommends \
        percona-server-server-5.7=${FULL_PERCONA_VERSION} \
        percona-server-common-5.7=${FULL_PERCONA_VERSION} \
        percona-server-tokudb-5.7=${FULL_PERCONA_VERSION}; \
    # TokuDB modifications
    # 安装tokudb时候需要输入到mysql文件里面
    echo "LD_PRELOAD=/usr/lib64/libjemalloc.so.1" >> /etc/default/mysql; \
    echo "THP_SETTING=never" >> /etc/default/mysql; \
    \
    # 清理并创建mysql目录
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql /etc/alternatives/my.cnf /etc/mysql/*; \
    mkdir -p /var/lib/mysql /var/log/mysql /var/run/mysqld /etc/mysql/conf.d; \
    # allow to change config files
    # 更改用户名跟组
    chown -R mysql:mysql /var/lib/mysql /var/log/mysql /var/run/mysqld /etc/mysql; \
    # ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
    chmod 1777 /var/run/mysqld

# 挂载两个卷
VOLUME ["/var/lib/mysql", "/var/log/mysql"]

# 拷贝entrypoint.sh和my.cnf文件到相应目录下面,这里写ppt的时候需要展示当前目录的文件层次,然后下面的人就看的清楚了,画图展示
COPY mysql-entry.sh /docker-entrypoint.sh
COPY --chown=mysql:mysql my.cnf /etc/mysql/my.cnf
ENTRYPOINT ["/docker-entrypoint.sh"]

# 暴露端口
EXPOSE 3306
# ENTRYPOINT和CMD就是启动mysqld命令,这个大家都知道,一个dockerfile里边只会有一个启动命令,这里需要确认下具体说法,然后写到ppt
# 类似docker run 镜像名字.....
CMD ["mysqld"]
