docker build -t talfers/complex-client:latest -t talfers/complex-client:$SHA -f ./client/Dockerfile ./client
docker build -t talfers/complex-server:latest -t talfers/complex-server:$SHA -f ./server/Dockerfile ./server
docker build -t talfers/complex-worker:latest -t talfers/complex-worker:$SHA -f ./worker/Dockerfile ./worker

# We already logged into docker in .travis.yml file
docker push talfers/complex-client:latest
docker push talfers/complex-server:latest
docker push talfers/complex-worker:latest

docker push talfers/complex-client:$SHA
docker push talfers/complex-server:$SHA
docker push talfers/complex-worker:$SHA

# We already installed kubectl in .travis.yml
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=talfers/complex-server:$SHA
kubectl set image deployments/client-deployment client=talfers/complex-client:$SHA
kubectl set image deployments/worker-deployment worker=talfers/complex-worker:$SHA
