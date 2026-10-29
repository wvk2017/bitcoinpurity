FROM ubuntu:22.04

RUN apt-get update -y && apt-get install wget -y

WORKDIR /opt/

# Hier is de URL nu helemaal schoon gemaakt en werkt de download correct
RUN wget https://github.com/saltduck/bitcoinpurity/releases/download/v1.1.0/bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz

RUN tar zxvf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz

RUN mv bitcoinpurity-1.1.0-x86_64-linux-gnu/bin/* /usr/bin/

# Schoonmaakactie om de image direct een stuk kleiner te maken (optioneel maar aangeraden)
RUN rm -rf bitcoinpurity-1.1.0-x86_64-linux-gnu.tar.gz bitcoinpurity-1.1.0-x86_64-linux-gnu

CMD ["/usr/bin/bitcoind", "-printtoconsole"]
