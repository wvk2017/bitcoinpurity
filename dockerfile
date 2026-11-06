# --- STAGE 1: Compileren van de broncode ---
FROM ubuntu:22.04 AS builder

# Voorkom dat apt-get blijft hangen op interactieve vragen
ARG DEBIAN_FRONTEND=noninteractive

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

# Haal de broncode op van de officiële repository
RUN git clone --depth 1 https://github.com .

# Start het build-proces
RUN ./autogen.sh && \
    ./configure --disable-wallet --without-gui --without-miniupnpc && \
    make -j$(nproc) && \
    make install

# --- STAGE 2: De uiteindelijke minimale runtime image ---
FROM ubuntu:22.04

# FIX: Moet OOK in stage 2 gedefinieerd worden om prompts te blokkeren
ARG DEBIAN_FRONTEND=noninteractive

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
