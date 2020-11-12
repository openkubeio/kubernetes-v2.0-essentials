#### Login onto nfs server node 192.168.205.14 

#### Install nfs server 
```
sudo apt-get update
sudo apt-get install nfs-server 
sudo systemctl status nfs-server
sudo apt install nfs-common
```

#### Create nfs shared directory and ownership
```
sudo mkdir /nfs/kubedata -p
sudo chown nobody:nogroup /nfs/kubedata
```

#### Update exports file
```
sudo tee -a /etc/exports << EOF
/nfs/kubedata    *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
## /nfs/general  192.168.205.13(rw,sync,no_subtree_check)
EOF
```

#### Exports nfs config
```
sudo exportfs -a
sudo exportfs -rva
```

#### Restart nfs server and check status
```
sudo systemctl restart nfs-server
sudo systemctl status nfs-server
```

#### Login onto client 192.168.205.13 and test nfs file share
```
sudo apt install nfs-common
sudo showmount -e 192.168.205.13
sudo mkdir /mynfs
sudo mount -t nfs 192.168.205.14:/nfs/kubedata /mynfs/
```
#### ------------------------------------------

#### Install nfs client on worker nodes
```
vagrant ssh worker1.dv.kube.io -- -t "sudo apt install nfs-common -y "
vagrant ssh worker2.dv.kube.io -- -t "sudo apt install nfs-common -y "
```

#### Apply below kubectl to create nfs provisioner
```
kubectl apply -f nfs-rbac.yaml
kubectl apply -f nfs-storage-class.yaml
kubectl apply -f nfs-provisioner.yaml
```

#### Quick test
```
kubectl apply -f nfs-pvc-test.yaml
kubectl get pv
kubectl get pvc
```

#### https://medium.com/@myte/kubernetes-nfs-and-dynamic-nfs-provisioning
#### https://blog.exxactcorp.com/deploying-dynamic-nfs-provisioning-in-kubernetes/
