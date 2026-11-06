FROM ubuntu:22.04

RUN apt-get update -y && apt-get install wget -y

WORKDIR /opt/

# De volledige en correcte URL naar het pakket
RUN wget https://github.com

RUN tar zxvf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz

# De correcte mapnaam na het uitpakken
RUN mv bitcoinpurity-1.1.0/bin/* /usr/bin/

CMD /usr/bin/bitcoind -printtoconsole
