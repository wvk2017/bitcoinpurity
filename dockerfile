# --- STAGE 1: Compileren van de broncode ---
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Installeer alle vereiste build-dependencies voor Bitcoin Knots/Purity
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libtool \
    autotools-dev \
    automake \
    pkg-config \
    bsdmainutils \
    python3 \
    libssl-dev \
    libevent-dev \
    libboost-dev \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/bitcoinpurity

# GECORRIGEERD: De volledige link naar de Bitcoin Purity repository
RUN git clone --depth 1 https://github.com .

# Start het build-proces
RUN ./autogen.sh && \
    ./configure --disable-wallet --without-gui --without-miniupnpc && \
    make -j$(nproc) && \
    make install

# --- STAGE 2: De uiteindelijke minimale runtime image ---
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installeer alleen de noodzakelijke runtime libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    libevent-2.1-7 \
    libevent-pthreads-2.1-7 \
    libboost-system1.74.0 \
    libboost-filesystem1.74.0 \
    libboost-thread1.74.0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Kopieer de gebouwde binaries uit de builder-stage
COPY --from=builder /usr/local/bin/bitcoind /usr/bin/bitcoind
COPY --from=builder /usr/local/bin/bitcoin-cli /usr/bin/bitcoin-cli

WORKDIR /root/.bitcoin

CMD ["/usr/bin/bitcoind", "-printtoconsole"]
