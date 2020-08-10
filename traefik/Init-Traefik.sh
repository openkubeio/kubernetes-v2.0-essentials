export app_hostname="traefik.dev.openkube.io"
export app_image="traefik:1.7.20"

export proxy_ip=192.168.210.10

# Cretae namespace traeik-ingress if not exists
[[ $(kubectl get ns | grep -E  "(^|\s)traefik($|\s)" | wc -l) == 1 ]] || kubectl create ns traefik

cat <<EOF | kubectl apply -f -	
---
apiVersion: v1
kind: Secret
metadata:
  name: ssl-traefik.secret.tls
  namespace: traefik
type: kubernetes.io/tls
data:
  tls.crt: $(cat certs/traefik.openkube.io.crt | base64 -w0 )
  tls.key: $(cat certs/traefik.openkube.io.key | base64 -w0 )
---  
EOF


kubectl apply -f ssl-traefik.serviceaccount.yaml
kubectl apply -f ssl-traefik.clusterrole.yaml
kubectl apply -f ssl-traefik.clusterrolebinding.yaml
kubectl apply -f ssl-traefik.configmap.yaml
envsubst < ssl-traefik.deployment.yaml | kubectl apply -f - 
kubectl apply -f ssl-traefik.service.yaml
kubectl apply -f ssl-traefik.service.dashboard.yaml 
envsubst < ssl-traefik.ingress.dashboard.yaml |kubectl apply -f -

kubectl get pods -n traefik
kubectl get svc -n traefik


echo "Traefik Running on https://${app_hostname}/ "


host_entry="${proxy_ip}  ${app_hostname}"
if [ $(cat /C/Windows/System32/drivers/etc/hosts | grep "$host_entry" | wc -l ) == 0  ] ; then
echo $host_entry >> /C/Windows/System32/drivers/etc/hosts 
fi;