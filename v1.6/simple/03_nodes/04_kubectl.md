# Install kubernetes kubectl

```

###### INSTALL BINARIES
wget  https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/



###### COPY ADMIN KUBECONFIG
cp ${WORKDIR}/assets/users/admin/kubeconfig ~/.kube/config



```
