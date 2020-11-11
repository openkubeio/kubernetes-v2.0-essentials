 kubectl get nodes -n kube-system -o=custom-columns=NAME:.metadata.name,ADDRESS:.status.addresses[*].address -l node-role.kubernetes.io/master
