FROM debian:stretch
MAINTAINER Francisco Rodriguez <frrodriguez@shutterfly.com>

ENV VERSION 2.0.8

RUN apt-get update && \
    apt-get install -y wget mysql-client inotify-tools procps && \
    wget https://github.com/sysown/proxysql/releases/download/v${VERSION}/proxysql_${VERSION}-debian9_amd64.deb --no-check-certificate -O /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    dpkg -i /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    rm -f /opt/proxysql_${VERSION}-debian9_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

RUN echo "Installing consul-template agent" && \
    apt update && \
    apt install -y wget unzip vim && \
    cd /usr/local/bin/ && \
    wget https://releases.hashicorp.com/consul-template/0.24.1/consul-template_0.24.1_linux_amd64.zip && \
    unzip consul-template_0.24.1_linux_amd64.zip && \
    rm -f consul-template_0.24.1_linux_amd64.zip

VOLUME /var/lib/proxysql
EXPOSE 6032 6033 6080

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
