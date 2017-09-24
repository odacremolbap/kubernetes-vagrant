## Create calico network policy components

```
cat <<EOF | kubectl create -f -

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-calico-cfg
  namespace: kube-system
data:

  cni_network_config: |-
    {
        "name": "k8s-pod-network",
        "cniVersion": "0.3.0",
        "type": "calico",
        "log_level": "debug",
        "datastore_type": "kubernetes",
        "nodename": "__KUBERNETES_NODE_NAME__",
        "ipam": {
            "type": "host-local",
            "subnet": "usePodCidr"
        },
        "policy": {
            "type": "k8s",
            "k8s_auth_token": "__SERVICEACCOUNT_TOKEN__"
        },
        "kubernetes": {
            "k8s_api_root": "https://__KUBERNETES_SERVICE_HOST__:__KUBERNETES_SERVICE_PORT__",
            "kubeconfig": "__KUBECONFIG_FILEPATH__"
        }
    }

---

apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: kube-calico
  namespace: kube-system
  labels:
    k8s-app: kube-calico
spec:
  selector:
    matchLabels:
      k8s-app: kube-calico
  template:
    metadata:
      labels:
        k8s-app: kube-calico
      annotations:
        scheduler.alpha.kubernetes.io/critical-pod: ''
    spec:
      hostNetwork: true
      serviceAccountName: kube-calico
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
        - key: "CriticalAddonsOnly"
          operator: "Exists"
      containers:
        - name: kube-calico
          image: quay.io/calico/node:v1.3.0
          env:
            - name: DATASTORE_TYPE
              value: "kubernetes"
            - name: FELIX_LOGSEVERITYSCREEN
              value: "info"
            - name: CALICO_NETWORKING_BACKEND
              value: "none"
            - name: CALICO_DISABLE_FILE_LOGGING
              value: "true"
            - name: FELIX_DEFAULTENDPOINTTOHOSTACTION
              value: "ACCEPT"
            - name: FELIX_IPV6SUPPORT
              value: "false"
            - name: WAIT_FOR_DATASTORE
              value: "true"
            - name: CALICO_IPV4POOL_CIDR
              value: "${KUBERNETES_POD_CIDR}"
            - name: CALICO_IPV4POOL_IPIP
              value: "always"
            - name: NODENAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: IP
              value: ""
          securityContext:
            privileged: true
          resources:
            requests:
              cpu: 250m
          volumeMounts:
            - mountPath: /var/run/calico
              name: var-run-calico
              readOnly: false
        - name: install-cni
          image: quay.io/calico/cni:v1.9.1-4-g23fcd5f
          command: ["/install-cni.sh"]
          env:
            - name: CNI_NETWORK_CONFIG
              valueFrom:
                configMapKeyRef:
                  name: kube-calico-cfg
                  key: cni_network_config
            - name: CNI_NET_DIR
              value: "/etc/kubernetes/cni/net.d"
            - name: KUBERNETES_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: SKIP_CNI_BINARIES
              value: bridge,cnitool,dhcp,flannel,host-local,ipvlan,loopback,macvlan,noop,portmap,ptp,tuning
          volumeMounts:
            - mountPath: /host/opt/cni/bin
              name: cni-bin-dir
            - mountPath: /host/etc/cni/net.d
              name: cni-net-dir
      volumes:
        - name: var-run-calico
          hostPath:
            path: /var/run/calico
        - name: cni-bin-dir
          hostPath:
            path: /opt/cni/bin
        - name: cni-net-dir
          hostPath:
            path: /etc/kubernetes/cni/net.d
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate

---

apiVersion: v1
kind: ServiceAccount
metadata:
  name: kube-calico
  namespace: kube-system

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: kube-calico
  namespace: kube-system
rules:
  - apiGroups: [""]
    resources:
      - namespaces
    verbs:
      - get
      - list
      - watch
  - apiGroups: [""]
    resources:
      - pods/status
    verbs:
      - update
  - apiGroups: [""]
    resources:
      - pods
    verbs:
      - get
      - list
      - watch
  - apiGroups: [""]
    resources:
      - nodes
    verbs:
      - get
      - list
      - update
      - watch
  - apiGroups: ["extensions"]
    resources:
      - thirdpartyresources
    verbs:
      - create
      - get
      - list
      - watch
  - apiGroups: ["extensions"]
    resources:
      - networkpolicies
    verbs:
      - get
      - list
      - watch
  - apiGroups: ["projectcalico.org"]
    resources:
      - globalconfigs
    verbs:
      - create
      - get
      - list
      - update
      - watch
  - apiGroups: ["projectcalico.org"]
    resources:
      - ippools
    verbs:
      - create
      - delete
      - get
      - list
      - update
      - watch
  - apiGroups: ["alpha.projectcalico.org"]
    resources:
      - systemnetworkpolicies
    verbs:
      - get
      - list
      - watch

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kube-calico
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: kube-calico
subjects:
- kind: ServiceAccount
  name: kube-calico
  namespace: kube-system

EOF


```
