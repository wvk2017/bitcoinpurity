FROM ubuntu:22.04

# DEBIAN_FRONTEND voorkomt dat installaties wachten op gebruikersinput
ENV DEBIAN_FRONTEND=noninteractive

# --no-install-recommends houdt de installatie compact en snel
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/

# De volledige en werkende download-link
RUN wget https://github.com

RUN tar zxvf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz && \
    mv bitcoinpurity-1.1.0/bin/* /usr/bin/ && \
    rm bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz

CMD ["/usr/bin/bitcoind", "-printtoconsole"]
