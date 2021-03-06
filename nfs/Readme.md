#### Check master nodes in cluster
```
kubectl get nodes -n kube-system -o=custom-columns=NAME:.metadata.name,ADDRESS:.status.addresses[*].address -l node-role.kubernetes.io/master
```

#### Export NFS node IP address
```
export NFS_SERVER=$(kubectl get nodes -n kube-system -o=custom-columns=IP:.status.addresses[0].address -l node-role.kubernetes.io/master | grep -v IP)
``` 
 
#### Create Nfs Provisioner 
```
kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes-v2.0-essentials/master/nfs/nfs-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes-v2.0-essentials/master/nfs/nfs-storage-class.yaml

curl -LO https://raw.githubusercontent.com/openkubeio/kubernetes-v2.0-essentials/master/nfs/nfs-provisioner.yaml
envsubst < nfs-provisioner.yaml | kubectl apply -f -  
```

#### Quick test nfs persistence provisioning
```
kubectl apply -f https://raw.githubusercontent.com/openkubeio/kubernetes-v2.0-essentials/master/nfs/nfs-pvc-test.yaml
kubectl get pv
kubectl get pvc 
```
