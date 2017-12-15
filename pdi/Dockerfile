#docker build . -t edrisse/mozart-etl-pdi

FROM openjdk:8u131-jdk-alpine

RUN apk --update add curl wget

RUN wget --tries=1000 https://netix.dl.sourceforge.net/project/pentaho/Data%20Integration/7.1/pdi-ce-7.1.0.0-12.zip -O /home/pdi.zip; \
	unzip /home/pdi.zip -d /home; \
	rm /home/pdi.zip;

RUN mkdir /root/.kettle
COPY kettle.properties /root/.kettle
COPY shared.xml /root/.kettle

RUN curl -k -L https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz -o /home/dockerize-linux-amd64-v0.2.0.tar.gz
#COPY dockerize-linux-amd64-v0.2.0.tar.gz /home/dockerize-linux-amd64-v0.2.0.tar.gz
RUN tar -C /usr/local/bin -xzvf /home/dockerize-linux-amd64-v0.2.0.tar.gz
RUN rm /home/dockerize-linux-amd64-v0.2.0.tar.gz

RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.44.zip -o /home/mysql-driver.zip
RUN unzip /home/mysql-driver.zip -d /home
RUN cp /home/mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /home/data-integration/lib
RUN rm /home/mysql-driver.zip
RUN rm -rf /home/mysql-connector-java-5.1.44

RUN curl -L https://github.com/esaude/emr-to-mozart-etl/archive/master.zip -o /home/master.zip
RUN unzip /home/master.zip -d /home
RUN rm /home/master.zip

CMD dockerize -wait tcp://emr-to-mozart-etl-mysql:3306 -timeout 3600s /home/data-integration/kitchen.sh -file /home/emr-to-mozart-etl-master/migrate-data.kjb run

