##############################################################################
#  Build Xenon
###############################################################################
# xenon比较简单，简单流程图画一下解释一下就好，跟mysql流程一样的，而且比较简单,画图的时候，可以把灰色的pod（装了xenon,mysql等容器）贴
# 在右边，然后流程图指向右边.

FROM golang:1.13-buster as builder

ARG XENON_BRANCH=feature_adapt_k8s
RUN set -ex; \
    mkdir -p /go/src/github.com/radondb; \
    cd /go/src/github.com/radondb; \
    git clone --branch $XENON_BRANCH https://github.com/radondb/xenon.git; \
    cd xenon; \
    make build

###############################################################################
#  Docker image for Xenon
###############################################################################

FROM alpine:3.13

RUN set -ex \
    # Create a group and user
    && addgroup -g 777 mysql && adduser -u 777 -g 777 -S mysql \
    && apk add --no-cache curl bash \
    && mkdir -p /etc/xenon /var/lib/xenon /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    && echo "/etc/xenon/xenon.json" > /config.path \
    # allow to change config files
    && chown -R 777:777 /etc/xenon /var/lib/xenon \
    && chmod u+s /bin/ping

COPY --from=builder --chown=777:777 /go/src/github.com/radondb/xenon/bin/xenon /usr/local/bin/xenon
COPY --from=builder --chown=777:777 /go/src/github.com/radondb/xenon/bin/xenoncli /usr/local/bin/xenoncli
COPY xenon-entry.sh /usr/local/bin/docker-entrypoint

USER 777
WORKDIR /
EXPOSE 8801
VOLUME ["/var/lib/xenon"]

ENTRYPOINT ["docker-entrypoint"]
CMD ["xenon", "-c", "/etc/xenon/xenon.json"]
