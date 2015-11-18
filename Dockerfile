FROM webdizz/baseimage-java8

CMD ["/sbin/my_init"]

RUN mkdir /home/spark; \
	curl http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/spark/spark-1.5.1/spark-1.5.1-bin-cdh4.tgz | \
	tar -C /home/spark -xvz
WORKDIR /home/spark

EXPOSE 8080 7077 6066 8081

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
