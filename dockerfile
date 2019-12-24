FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install postgresql python3.7 python3
