#!/usr/bin/env bash

# Clean up
docker stop master &> /dev/null
docker rm master &> /dev/null
for SLAVE in spark1 spark2 spark3 spark4 spark5
do
	docker stop ${SLAVE} &> /dev/null
	docker rm ${SLAVE} &> /dev/null
done

# Add host to spark cluster network
sudo ip addr add 192.168.1.254/24 dev br1

# Run spark master image
docker run --name="master" -h master \
	--add-host master:192.168.1.10 \
	--add-host spark1:192.168.1.11 \
	--add-host spark2:192.168.1.12 \
	--add-host spark3:192.168.1.13 \
	--add-host spark4:192.168.1.14 \
	--expose=1-65535 \
	--env SPARK_MASTER_IP=192.168.1.10 \
	-d tkurylek/spark:latest

# Add spark master image to spark cluster network
sudo pipework br1 master 192.168.1.10/24

# Start spark master
docker exec master ./spark-1.5.1-bin-cdh4/sbin/start-master.sh

# Same with children
for SLAVE_ID in 1 2 3 4 5
do
	docker run --name="spark${SLAVE_ID}" -h spark${SLAVE_ID} \
		--add-host home:192.168.1.8 \
		--add-host master:192.168.1.10 \
		--add-host spark1:192.168.1.11 \
		--add-host spark2:192.168.1.12 \
		--add-host spark3:192.168.1.13 \
		--add-host spark4:192.168.1.14 \
		--expose=1-65535 \
		--memory=1G
		--env master=spark://192.168.1.10:7077 \
		-d tkurylek/spark:latest
	sudo pipework br1 spark${SLAVE_ID} 192.168.1.1${SLAVE_ID}/24
	docker exec spark${SLAVE_ID} ./spark-1.5.1-bin-cdh4/sbin/start-slave.sh spark://192.168.1.10:7077
done

# Verification
# curl -IL 192.168.1.10:8080