#!/bin/sh


cd $TRAVIS_BUILD_DIR/aviasales2
docker build -t hockeyegor/aviasales2:latest -t hockeyegor/aviasales2:$BUILD_ID -f ./Dockerfile .
cd $TRAVIS_BUILD_DIR
ls -l
echo $PWD
docker build -t hockeyegor/ngcrmdev:latest -t hockeyegor/ngcrmdev:$BUILD_ID -f ./ngcrmdev/Dockerfile ./ngcrmdev
docker push hockeyegor/aviasales2:latest
docker push hockeyegor/ngcrmdev:latest

docker push hockeyegor/aviasales2:$BUILD_ID
docker push hockeyegor/ngcrmdev:$BUILD_ID

kubectl apply -f ./contacts-deployment/k8s
kubectl set image deployments/ngcrmdev-deployment ngcrmdev=hockeyegor/ngcrmdev:$BUILD_ID
kubectl set image deployments/aviasales2-deployment contacts-api=hockeyegor/aviasales2:$BUILD_ID
