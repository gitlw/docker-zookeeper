FROM lucasatucla/docker-base
LABEL maintainer="lucasatucla@gmail.com"
ENV ZOOKEEPER_VERSION 3.5.6
ENV ZK_NAME apache-zookeeper-${ZOOKEEPER_VERSION}-bin

RUN wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZK_NAME}.tar.gz && \
wget -q https://www.apache.org/dist/zookeeper/KEYS && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZK_NAME}.tar.gz.asc && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/${ZK_NAME}.tar.gz.sha512

# Verify download
RUN sha512sum -c ${ZK_NAME}.tar.gz.sha512 && \
gpg --import KEYS && \
gpg --verify ${ZK_NAME}.tar.gz.asc

# Install
RUN tar -xzf ${ZK_NAME}.tar.gz -C /opt

# Configure
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ZK_HOME /opt/${ZK_NAME}
RUN mv ${ZK_HOME}/conf/zoo_sample.cfg ${ZK_HOME}/conf/zoo.cfg
RUN sed  -i "s|/tmp/zookeeper|${ZK_HOME}/data|g" ${ZK_HOME}/conf/zoo.cfg; mkdir ${ZK_HOME}/data

EXPOSE 2181

WORKDIR ${ZK_HOME}
VOLUME ["${ZK_HOME}/conf", "${ZK_HOME}/data"]

CMD ${ZK_HOME}/bin/zkServer.sh start-foreground


