FROM ubuntu as builder

WORKDIR /usr/app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    git \
    openssh-client \
    python3 \
    python3-dev \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Chia-Network/chiapos.git && cd chiapos

RUN cd chiapos && \
    mkdir -p build && \
    cmake -B build && \
    cd build && \
    cmake --build . -- -j `nproc`

FROM ubuntu
COPY --from=builder /usr/app/chiapos/build/ProofOfSpace /usr/local/bin/chiapos
