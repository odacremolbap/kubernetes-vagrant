# Create kubeconfigs

```

###### Controller Manager

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/master/controller-manager.kubeconfig

kubectl config set-credentials cm \
  --client-certificate=${WORKDIR}/assets/certs/controller-manager/cm.crt \
  --client-key=${WORKDIR}/assets/certs/controller-manager/cm.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/master/controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=cm \
  --kubeconfig=${WORKDIR}/assets/master/controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/master/controller-manager.kubeconfig




###### Scheduler

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/master/scheduler.kubeconfig

kubectl config set-credentials scheduler \
  --client-certificate=${WORKDIR}/assets/certs/scheduler/scheduler.crt \
  --client-key=${WORKDIR}/assets/certs/scheduler/scheduler.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/master/scheduler.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=scheduler \
  --kubeconfig=${WORKDIR}/assets/master/scheduler.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/master/scheduler.kubeconfig


###### Admin

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/users/admin/kubeconfig

kubectl config set-credentials admin \
  --client-certificate=${WORKDIR}/assets/users/admin/admin.crt \
  --client-key=${WORKDIR}/assets/users/admin/admin.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/users/admin/kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=admin \
  --kubeconfig=${WORKDIR}/assets/users/admin/kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/users/admin/kubeconfig



###### Master Kubelet

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/kubelet.kubeconfig

kubectl config set-credentials master \
  --client-certificate=${WORKDIR}/assets/nodes/master1/master1.crt \
  --client-key=${WORKDIR}/assets/nodes/master1/master1.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/kubelet.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=master \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/kubelet.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/nodes/master1/kubelet.kubeconfig



###### Worker1 Kubelet

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/nodes/worker1/kubelet.kubeconfig

kubectl config set-credentials worker1 \
  --client-certificate=${WORKDIR}/assets/nodes/worker1/worker1.crt \
  --client-key=${WORKDIR}/assets/nodes/worker1/worker1.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/nodes/worker1/kubelet.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=worker1 \
  --kubeconfig=${WORKDIR}/assets/nodes/worker1/kubelet.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/nodes/worker1/kubelet.kubeconfig



###### Worker2 Kubelet

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/nodes/worker2/kubelet.kubeconfig

kubectl config set-credentials worker2 \
  --client-certificate=${WORKDIR}/assets/nodes/worker2/worker2.crt \
  --client-key=${WORKDIR}/assets/nodes/worker2/worker2.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/nodes/worker2/kubelet.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=worker2 \
  --kubeconfig=${WORKDIR}/assets/nodes/worker2/kubelet.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/nodes/worker2/kubelet.kubeconfig



###### Master Proxy

kubectl config set-cluster local \
  --certificate-authority ${WORKDIR}/assets/certs/ca/ca.crt \
  --embed-certs=true \
  --server=https://${APISERVER_IP1}:6443 \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/proxy.kubeconfig

kubectl config set-credentials proxy \
  --client-certificate=${WORKDIR}/assets/certs/proxy/proxy.crt \
  --client-key=${WORKDIR}/assets/certs/proxy/proxy.key \
  --embed-certs=true \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/proxy.kubeconfig

kubectl config set-context default \
  --cluster=local \
  --user=proxy \
  --kubeconfig=${WORKDIR}/assets/nodes/master1/proxy.kubeconfig

kubectl config use-context default --kubeconfig=${WORKDIR}/assets/nodes/master1/proxy.kubeconfig



###### TODO (other proxies copied from this one. We should create a cert for each of them)
cp ${WORKDIR}/assets/nodes/master1/proxy.kubeconfig ${WORKDIR}/assets/nodes/worker1/proxy.kubeconfig
cp ${WORKDIR}/assets/nodes/master1/proxy.kubeconfig ${WORKDIR}/assets/nodes/worker2/proxy.kubeconfig

cd


```
