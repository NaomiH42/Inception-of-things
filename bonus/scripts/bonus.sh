helm repo add gitlab https://charts.gitlab.io/

helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --create-namespace \
  --timeout 600s \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=127.0.0.1 \
  --set certmanager-issuer.email=me@example.co


kubectl wait --for=condition=available --timeout=300s deployment/gitlab-nginx-ingress-controller -n gitlab



echo "Gitlab root password:"
INITIAL_PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode ; echo)
echo $INITIAL_PASSWORD

kubectl get configmap coredns -n kube-system -o yaml > ../confs/coredns.yaml

CONFIG_FILE="../confs/coredns.yaml"
NEW_IP=$(kubectl get svc gitlab-nginx-ingress-controller -n gitlab | awk 'NR==2 {print $3}')
grep -q 'gitlab\.example\.com' "$CONFIG_FILE" || sed -i.bak -E '/^kind:[[:space:]]*ConfigMap/i\    '"${NEW_IP}"' gitlab.example.com' "$CONFIG_FILE"

kubectl apply -f ../confs/coredns.yaml
kubectl rollout restart deployment coredns -n kube-system

echo $INITIAL_PASSWORD

nohup kubectl port-forward svc/gitlab-nginx-ingress-controller 4443:443 -n gitlab > /dev/null 2>&1 &
nohup kubectl port-forward svc/gitlab-nginx-ingress-controller -n gitlab 4242:22 > /dev/null 2>&1 &

read -p "Create repository 'test' with user root and press Enter..."

argocd repo add https://gitlab.example.com/root/test.git \
  --username root \
  --password $INITIAL_PASSWORD \
  --insecure-skip-server-verification

kubectl apply -f ../confs/argocd-app-bonus.yaml

# git clone ssh://git@gitlab.example.com:2222/root/test.git