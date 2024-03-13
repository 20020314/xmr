# 第一阶段：构建应用程序
FROM alpine AS builder
WORKDIR /usr/local/XMR
COPY . /usr/local/XMR
RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    apk add --no-cache bash && \
    chmod +x /usr/local/XMR/xmrig

# 第二阶段：运行时镜像
FROM alpine AS run
COPY --from=builder /usr/local/XMR /usr/local/XMR
RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    apk add --no-cache bash
WORKDIR /usr/local/XMR
CMD ["bash", "-c", "/usr/local/XMR/xmrig"]
