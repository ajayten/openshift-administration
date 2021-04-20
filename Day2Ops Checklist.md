# Day 2 Operations Checklist


## Authentication

### LDAP

- [ ] LDAP CA Certificate (Chain)
- [ ] Readonly bind user
- [ ] Check firewall
- [ ] apply oauth configuration
- [ ] check oauth pods in namespace openshift-authentication and wait for both pods to be ready
- [ ] login with new identity provider

### RBAC

- [ ] apply rbac config


### Delete kubeadmin user

- [ ] Attention: Make sure you have at least one other cluster-admin user available
- [ ] delete secret "kubeadmin" in namespace "kube-system"
- [ ] check oauth pods in namespace openshift-authentication and wait for both pods to be ready


## Certificates

### Cert Manager

- [ ] prepare dynamic dns zone
- [ ] check if all static dns entries are still available (*.apps , api)
- [ ] adjust dns issuer for dynamic dns parameters
- [ ] add dynamic dns update secret to cluster
- [ ] apply cert-manager deployment
- [ ] check for pod rollout in namespace "cert-manager"

### Aquire certificates

- [ ] check for DNS name in router-cert
- [ ] check for DNS name in api-cert
- [ ] apply certificate resources
- [ ] wait for certificates to become ready

### Ingress Controller Config

- [ ] check certificate secret to be present (namespace openshift-ingress)
- [ ] apply ingress controller config
- [ ] wait for router pods to roll out (namespace openshift-ingress)


### API Server Config

- [ ] check dns name in apiserver config
- [ ] check certificate secret to be present (namespace openshift-config)
- [ ] apply apiserver config
- [ ] wait for kube-apiserver operator to update
- [ ] wait for openshift-apiserver operator to update 



## Storage

### NFS

- [ ] Check NFS Server configuration (exports, ip ranges)
- [ ] Check Firewall
- [ ] Adjust NFS server address in deployment
- [ ] Adjust NFS server address in persistent volume (pv)
- [ ] Apply NFS configuration


### Image Registry

- [ ] Check NFS Server configuration (exports, ip ranges)
- [ ] Check Firewall
- [ ] Adjust NFS server address in persistent volume (pv)
- [ ] Apply NFS configuration
- [ ] check for pod rollout in namespace "openshift-storage"

## Monitoring

### Monitoring Config

- [ ] Check storage class in config map
- [ ] apply config map to namespace "openshift-monitoring"
- [ ] check for pod rollout in namespace "openshift-monitoring"

### Alerts

### Service Monitors
