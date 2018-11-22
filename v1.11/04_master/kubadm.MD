# Init

kubeadm/app/apis/kubeadm/v1alpha2/types.go
contains MasterConfiguration type

- bootstraptokens == sensitive, not uploaded to configmap
    token <-- string that creates trust between nodes and master
    description
    ttl <-- defaults to 24h
    expires <-- I'd use TTL rahter than this one
    usages <-- description of usages (??)
    groups <-- extra groups this token will authenticate as

- nodeRegistration == info to register the new master node
    name <-- defaults to hostname. Will be used at the CN of the kubelet certificate
    criSocket
    taints <-- defaults to []v1.Taint{'node-role.kubernetes.io/master=""'}
    kubeletExtraArgs <-- local to the node kubeadm init is running

- api == info for the apiserver
    advertiseAddress
    bindPort
    controlPlaneEndpoint <-- LB IP or DNS

- kubeProxy
    config <-- kubeproxyconfigv1alpha1.KubeProxyConfiguration

- etcd == config for the etcd
    - local
        image
        datadir <-- defaults to /var/lib/etcd
        extraArgs <-- for the static pod
        serverCertSANs
        peerCertSANs
    - external
        endpoints
        caFile
        certFile
        keyFile

- kubeletConfiguration == config for the kubelet
    - baseConfig <-- kubeletconfigv1beta1.KubeletConfiguration

- networking == config for networkingnodeRegistration
    serviceSubnet
    podSubnet
    dnsDomain <-- defaults to cluster.local

-- kubernetesVersion == kube version

[All this should be configured using ComponentConfig in the future ]
-- apiServerExtraArgs <<-- temporary, better not use it
-- controllerManagerExtraArgs <<-- temporary, better not use it
-- schedulerExtraArgs <<-- temporary, better not use it

-- apiServerExtraVolumes extra set of host volumes mounted to the apiserver
-- controllerManagerExtraVolumes extra set of host volumes mounted to the controllerManager
-- schedulerExtraVolumes extra set of host volumes mounted to the scheduler
        For all these (name, hostmapth, mountpath, writable, pathtype)

-- apiServerCertSANs
-- certificatesDir
-- imageRepository
-- unifiedControlPlaneImage ??

-- auditPolicy == configuration for the audit policy
    - path <-- to a local audit policy
    - logDir <-- where logs will be stored
    - logMaxAge <-- days logs will be stored

-- featureGates


# Join

kubeadm/app/apis/kubeadm/v1alpha2/types.go
contains NodeConfiguration type (should be replaced by dynamic kubelet configuration)

- nodeRegistration <-- info to register the new node
    caCertPath
    discoveryFile <-- URL to a kubeconfig to load cluster info
    discoveryToken <-- token used for discovery
    discoveryTokenAPIServers <-- (currently only the first is used)
    discoveryTimeout
    tlsBootstrapToken <-- token used for TLS bootstrapping (defaults to Token ??)
    token <-- used for discovery and TLS
    cluster <-- name for the cluster at the kubeconfig
    discoveryTokenCACertHashes <-- sha256 of the root CA for discovery (or empty)
    discoveryTokenUnsafeSkipCAVerification <-- disables CA verification
    featureGates
