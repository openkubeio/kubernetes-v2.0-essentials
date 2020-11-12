## export NFS_SERVER=192.168.210.10
export NFS_SERVER=$(kubectl get nodes -n kube-system -o=custom-columns=IP:.status.addresses[0].address -l node-role.kubernetes.io/master | grep -v IP)

# apply nfs provisioner
kubectl apply -f nfs-rbac.yaml
kubectl apply -f nfs-storage-class.yaml
envsubst < nfs-provisioner.yaml | kubectl apply -f -  


# Quick test
kubectl apply -f nfs-pvc-test.yaml
kubectl get pv
kubectl get pvc 
