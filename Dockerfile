FROM debian:stretch-slim

ARG ELASTIC_VERSION=1.7.6
ARG JAVA_PARAMETERS
ENV JAVA_PARAMETERS=$JAVA_PARAMETERS

RUN apt-get update -qq \
  && apt-get upgrade -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  build-essential \
  procps \ 
  ca-certificates \
  apt-utils \
  curl \
  openjdk-8-jdk

RUN apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN curl -o /usr/local/bin/evm https://raw.githubusercontent.com/duydo/evm/master/evm
RUN chmod +x /usr/local/bin/evm
RUN evm install $ELASTIC_VERSION
RUN evm use $ELASTIC_VERSION

CMD evm start & sleep infinity

EXPOSE 9200

