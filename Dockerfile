FROM ubuntu:18.04
RUN apt-get clean
RUN apt-get -y update
RUN apt-get -y upgrade
ENTRYPOINT /bin/bash
