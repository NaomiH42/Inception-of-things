NEW_PASSWORD="admin123"
ARGOCD_SERVER="localhost:8080"


k3d cluster delete iot
k3d cluster create iot --port 8080:443@loadbalancer --port 8888:8888@loadbalancer  --port 2222:22@loadbalancer --port 8889:8889@loadbalancer

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'




kubectl wait --namespace argocd --for=condition=ready pod --all --timeout=300s
INITIAL_PASSWORD=$(argocd admin initial-password -n argocd | head -1)

argocd login $ARGOCD_SERVER --username admin --password $INITIAL_PASSWORD --insecure

argocd account update-password \
  --current-password "${INITIAL_PASSWORD}" \
  --new-password "${NEW_PASSWORD}" \
  --server ${ARGOCD_SERVER}

kubectl create namespace dev
kubectl apply -f ../confs/argocd-app.yaml

