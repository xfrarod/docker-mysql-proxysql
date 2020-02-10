FROM golang:alpine

EXPOSE 3000

ENV GOPATH=/tmp/go

RUN set -ex \
    && apk add --update --no-cache bash \
    && apk add --update --no-cache --virtual .build-deps rsync go build-base git ruby ruby-dev \
    && apk add mysql-client \
    && gem install fpm \
    && cd /tmp \
    && { go get -d github.com/github/orchestrator ; : ; } \
    && cd $GOPATH/src/github.com/github/orchestrator \
    && bash build.sh -P -b \
    && rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator -maxdepth 2)/ / \
    && rsync -av $(find /tmp/orchestrator-release -type d -name orchestrator-cli -maxdepth 2)/ / \
    && cd / \
    && apk del .build-deps \
    && rm -rf /tmp/* \
    && mkdir -p /var/lib/orchestrator \

ENV PATH=$PATH:/usr/local/orchestrator/resources/bin/

WORKDIR /usr/local/orchestrator
CMD /usr/local/orchestrator/orchestrator http