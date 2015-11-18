# Spark cluster on docker
## Dependencies
- [Pipework](https://github.com/jpetazzo/pipework)
```
sudo bash -c "curl https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework > /usr/local/bin/pipework"
```
- [Docker](http://docker.io/)

## Running
To set up spark cluster run script
```
./start-spark-cluster.sh
```
then access the master's web ui:
```
http://192.168.1.10:8080/
```

## Stopping
To stop spark cluster issue
```
./stop-spark-cluster.sh
```
