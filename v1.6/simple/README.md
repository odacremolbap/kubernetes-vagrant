# Kubernetes 1.6 playground

## Layout

Masters: master1
Workers: master1, worker1, worker2

## Details
  - Only 1 network interface explicitly created at Vagrant
  - Created under root account (not recommended)

### Certificates
  - 1 CA for all components
  - 1 apiserver key pair
  - 1 controller-manager key pair `/CN=system:kube-controller-manager`
  - 1 scheduler key pair `/CN=system:kube-scheduler`
  - 1 etcd key pair
  - 1 etcd-client key pair
  - 3 kubelet key pairs `/CN=system:nodes:NAME/O=system:nodes`
  - 1 proxy key pair `/CN=system:kube-proxy/O=system:node-proxier` (probably there should be 3)
  - 1 admin user key pair `/CN=admin/O=system:masters`

## Installation

This process is fairly manual.

1. Get into the vagrant folder `01_vagrant` and execute `vagrant up`. (You might want to customize the memory specs for the nodes, currently 2GB each)
2. Log into the master using `vagrant ssh master1` and execute all master scripts at `02_master` from 00 to 06. The first step does `sudo su -` and creates some environment variables that are needed for the other master steps. If you need to repeat any step, make sure you are root and that the environment variables have been created
3. Log into the master using `vagrant ssh master1` and execute all the master scripts from 00 to 06. The first step does `sudo su -` and creates some environment variables that are needed for the other master steps. If you need to repeat any step, make sure you are root and that the environment variables have been created
4. Iterate all nodes (including master, if you want to have 3 working nodes). At each iteration modify the `WORKER_NAME` environment variable at the first step at `03_nodes` with the name of the node are using. Execute each step as you did with the master
5. After the previous step we still need to setup networking. Connect to any node and execute all steps one after the other.
