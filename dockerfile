FROM ubuntu:22.04

WORKDIR /opt/

RUN apt-get update -y && \
    apt-get install wget -y && \
    wget https://github.com && \
    tar zxvf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz && \
    mv bitcoinpurity-1.1.0-x86_64-linux-gnu/bin/* /usr/bin/ && \
    rm -rf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz bitcoinpurity-1.1.0-x86_64-linux-gnu && \
    apt-get purge -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/bitcoind", "-printtoconsole"]
