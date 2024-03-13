FROM alpine
WORKDIR /usr/local/XMR
COPY . /usr/local/XMR
RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    apk add bash && \
    chmod +x /usr/local/XMR/xmrig
CMD ["bash", "-c", "/usr/local/XMR/xmrig"]
