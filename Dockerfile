# 使用Alpine Linux作为基础镜像
FROM alpine:latest

# 安装构建工具和依赖项
RUN apk --no-cache add \
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

# 克隆XMRig存储库
RUN git clone https://github.com/xmrig/xmrig.git /xmrig

# 创建构建目录并构建XMRig
RUN cd /xmrig && \
    mkdir build && \
    cd scripts && \
    ./build_deps.sh && \
    cd ../build && \
    cmake .. -DXMRIG_DEPS=../scripts/deps -DBUILD_STATIC=ON && \
    make -j$(nproc)

# 设置工作目录
WORKDIR /xmrig/build

# 启动命令
CMD ["./xmrig"]
