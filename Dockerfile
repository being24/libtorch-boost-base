FROM nvidia/cuda:11.7.1-base-ubuntu22.04

ENV LC_CTYPE='C.UTF-8'
ENV LC_ALL='C.UTF-8'
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /workdir/

RUN set -x && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends curl git build-essential libssl-dev cmake nano iproute2 unzip&& \
    curl https://getmic.ro | bash && \
    mv micro /usr/bin && \
    curl -L -O https://boostorg.jfrog.io/artifactory/main/release/1.82.0/source/boost_1_82_0.tar.bz2 && \
    tar -xf ./boost_1_82_0.tar.bz2 && \
    rm -rf ./boost_1_82_0.tar.bz2 && \
    cd ./boost_1_82_0 && \
    sh ./bootstrap.sh && \
    ./b2 install -j2 -j $(grep cpu.cores /proc/cpuinfo | sort -u | awk '{split($0, ary, ": "); print(ary[2] + 1)}' ) && \
    cd /workdir && \
    rm -rf boost_1_82_0 && \
    curl -L -O https://download.pytorch.org/libtorch/cu117/libtorch-cxx11-abi-shared-with-deps-2.0.1%2Bcu117.zip && \
    unzip ./libtorch-cxx11-abi-shared-with-deps-2.0.1%2Bcu117.zip && \
    rm -rf ./libtorch-cxx11-abi-shared-with-deps-2.0.1%2Bcu117.zip && \
    mv ./libtorch ~/libtorch && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

