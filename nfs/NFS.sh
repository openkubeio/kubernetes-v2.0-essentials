export NFS_SERVER=192.168.210.10

kubectl apply -f nfs-rbac.yaml
kubectl apply -f nfs-storage-class.yaml
envsubst < nfs-provisioner.yaml | kubectl apply -f -  


# Quick test
kubectl apply -f nfs-pvc-test.yaml
kubectl get pv
kubectl get pvc 