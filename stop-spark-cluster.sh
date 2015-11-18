#!/usr/bin/env bash
docker stop master
docker rm master
for SLAVE in spark1 spark2 spark3 spark4 spark5
do
	docker stop ${SLAVE}
	docker rm ${SLAVE}
done