FROM ubuntu:18.04

ENTRYPOINT /bin/bash

RUN apt-get clean
RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install postgresql
RUN apt-get python3.7
RUN apt-get python

RUN systemctl enable postgresql

RUN mkdir -p /opt/selene
RUN chown -R mycroft:users /opt/selene
RUN cd /opt/selene
RUN git clone https://github.com/MycroftAI/selene-backend.git

RUN Python3.7 -m pip install pipenv
RUN cd /opt/selene/selene-backend/db
RUN pipenv install

RUN mkdir -p /opt/selene/data
RUN cd /opt/selene/data
RUN wget http://download.geonames.org/export/dump/countryInfo.txt
RUN wget http://download.geonames.org/export/dump/timeZones.txt
RUN wget http://download.geonames.org/export/dump/admin1CodesASCII.txt
RUN wget http://download.geonames.org/export/dump/cities500.zip

USER postgres

RUN psql -c "ALTER USER postgres PASSWORD 'password$$'"
RUN psql -c "CREATE ROLE selene WITH LOGIN ENCRYPTED PASSWORD 'password$$'"

RUN export DB_PASSWORD='password$$'
RUN export POSTGRES_PASWORD='password$$'

RUN cd /opt/selene/selene-backend/db/scripts
RUN pipenv run python bootstrap_mycroft_db.py

RUN mkdir -p /test
WORKDIR /test
COPY wait_service.py /test/
CMD python wait_service.py
