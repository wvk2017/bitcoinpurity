FROM ubuntu:22.04
RUN apt-get update -y
RUN apt-get install wget -y
WORKDIR /opt/
RUN wget https://github.com/saltduck/bitcoinpurity/releases/download/v1.1.0/bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz
RUN tar zxvf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz
RUN mv bitcoinpurity-1.1.0-x86_64-linux-gnu/bin/* /usr/bin/
CMD /usr/bin/bitcoinpurityd -printtoconsole
