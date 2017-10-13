FROM alpine:3.4

ENV MYSQL_ROOT_PASSWORD=eSaudeRootMySQLPassword
ENV MYSQL_DATABASE=openmrs
ENV MYSQL_USER=esaude
ENV MYSQL_PASSWORD=eSaudeUserMySQLPassword
ENV MYSQL_DATA_DIRECTORY=/opt/esaude/data/system/mysql

ADD esaude-mysql.cnf /root/.my.cnf

RUN apk add --update mariadb mariadb-client curl zip unzip;
RUN apk del curl unzip && rm -f /var/cache/apk/*;
RUN rm /usr/bin/mysql_client_test_embedded;
RUN rm /usr/bin/mysqltest;
RUN rm /usr/bin/mysqltest_embedded;

RUN mkdir /startup-scripts
ADD export_db.sql /startup-scripts/export_db.sql
ADD openmrs-structure.sql /startup-scripts/openmrs-structure.sql

COPY run.sh /run.sh

VOLUME /opt/esaude/data

EXPOSE 3306

CMD ["/run.sh"]

