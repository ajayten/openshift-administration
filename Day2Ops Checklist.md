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

- [ ] apply rbac config `oc apply -k auth/`


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
- [ ] apply cert-manager deployment `oc apply -k cert-manager/`
- [ ] check for pod rollout in namespace "cert-manager"

### Aquire certificates

- [ ] check for DNS name in router-cert
- [ ] check for DNS name in api-cert
- [ ] apply certificate resources `oc apply -f cluster-config/certificates/`
- [ ] wait for certificates to become ready

### Ingress Controller Config

- [ ] check certificate secret to be present (namespace openshift-ingress)
- [ ] apply ingress controller config `oc apply -f cluster-config/ingress-controller.yaml`
- [ ] wait for router pods to roll out (namespace openshift-ingress)


### API Server Config

- [ ] check dns name in apiserver config
- [ ] check certificate secret to be present (namespace openshift-config)
- [ ] apply apiserver config `oc apply -f cluster-config/apiserver.yaml`
- [ ] wait for kube-apiserver operator to update
- [ ] wait for openshift-apiserver operator to update 



## Storage

### NFS

- [ ] Check NFS Server configuration (exports, ip ranges)
- [ ] Check Firewall
- [ ] Adjust NFS server address in deployment
- [ ] Adjust NFS server address in persistent volume (pv)
- [ ] Apply NFS configuration `oc apply -k nfs/`


### Image Registry

- [ ] Check NFS Server configuration (exports, ip ranges)
- [ ] Check Firewall
- [ ] Adjust NFS server address in persistent volume (pv)
- [ ] Apply NFS configuration `oc apply cluster-config/image-registry/` 
- [ ] check for pod rollout in namespace "openshift-storage"

## Monitoring

### Monitoring Config

- [ ] Check storage class in config map
- [ ] apply config map to namespace "openshift-monitoring" `oc apply -f monitoring/config,yaml`
- [ ] check for pod rollout in namespace "openshift-monitoring"

### Alerts & Service Monitors


- apply monitoring configuration `oc apply -k monitoring/`



# Resources

https://www.openshift.com/blog/mitigate-impact-of-docker-hub-pull-request-limits

