#!/bin/bash 

array=('kube-apiserver' 'kube-controller-manager' 'kube-scheduler' 'kube-proxy' 'kubelet')
for data in ${array[@]} 
do 
    pid=$(ps -aux | grep ${data} | grep -v grep | awk '{print $2}')

    echo "$data  pid $pid  "
    if [ -n "$pid" ]; then
        kill $pid
        echo "kill $data"
    fi
done

./kube-apiserver --apiserver-count=1 --insecure-bind-address=127.0.0.1 --insecure-port=8080 --runtime-config=admissionregistration.k8s.io/v1alpha1 --service-node-port-range=30000-32767 --storage-backend=etcd3 --admission-control=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ValidatingAdmissionWebhook,ResourceQuota --allow-privileged=true --requestheader-client-ca-file=/etc/kubernetes/ssl/front-proxy-ca.crt --requestheader-group-headers=X-Remote-Group --requestheader-allowed-names=front-proxy-client --tls-cert-file=/etc/kubernetes/ssl/apiserver.crt --kubelet-client-certificate=/etc/kubernetes/ssl/apiserver-kubelet-client.crt --enable-bootstrap-token-auth=true --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --service-cluster-ip-range=10.233.0.0/18 --tls-private-key-file=/etc/kubernetes/ssl/apiserver.key --proxy-client-key-file=/etc/kubernetes/ssl/front-proxy-client.key --requestheader-extra-headers-prefix=X-Remote-Extra- --service-account-key-file=/etc/kubernetes/ssl/sa.pub --client-ca-file=/etc/kubernetes/ssl/ca.crt --requestheader-username-headers=X-Remote-User --advertise-address=192.168.111.34 --kubelet-client-key=/etc/kubernetes/ssl/apiserver-kubelet-client.key --secure-port=6443 --proxy-client-cert-file=/etc/kubernetes/ssl/front-proxy-client.crt --authorization-mode=Node,RBAC --etcd-servers=https://192.168.111.34:2379 --etcd-cafile=/etc/kubernetes/ssl/etcd/ca.pem --etcd-certfile=/etc/kubernetes/ssl/etcd/node-hzc-master1.pem --etcd-keyfile=/etc/kubernetes/ssl/etcd/node-hzc-master1-key.pem --feature-gates=CustomPodDNS=true    >apiserver.log  2>&1 &


./kube-controller-manager --feature-gates=Initializers=true,PersistentLocalVolumes=False --node-monitor-grace-period=40s --node-monitor-period=5s --pod-eviction-timeout=5m0s --cluster-signing-key-file=/etc/kubernetes/ssl/ca.key --address=127.0.0.1 --leader-elect=true --root-ca-file=/etc/kubernetes/ssl/ca.crt --cluster-signing-cert-file=/etc/kubernetes/ssl/ca.crt --use-service-account-credentials=true --controllers=*,bootstrapsigner,tokencleaner --kubeconfig=/etc/kubernetes/controller-manager.conf --service-account-private-key-file=/etc/kubernetes/ssl/sa.key --allocate-node-cidrs=true --cluster-cidr=10.233.64.0/18 --node-cidr-mask-size=24     >controller-manager.log  2>&1 &

./kube-scheduler --address=127.0.0.1 --leader-elect=true --kubeconfig=/etc/kubernetes/scheduler.conf   >scheduler.log 2>&1  &

./kube-proxy --config=/var/lib/kube-proxy/config.conf   >proxy.log 2>&1  &


./kubelet --logtostderr=true --v=2 --address=192.168.111.34 --node-ip=192.168.111.34 --hostname-override=hzc-master1 --allow-privileged=true --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig --authorization-mode=Webhook --client-ca-file=/etc/kubernetes/ssl/ca.crt --pod-manifest-path=/etc/kubernetes/manifests --cadvisor-port=0 --pod-infra-container-image=hub.easystack.io/captain/pause-amd64:3.0 --kube-reserved cpu=100m,memory=256M --node-status-update-frequency=10s --cgroup-driver=cgroupfs --docker-disable-shared-pid=True --anonymous-auth=false --fail-swap-on=True --feature-gates=CustomPodDNS=true --cluster-dns=10.233.0.3 --cluster-domain=cluster.local --resolv-conf=/etc/resolv.conf --kube-reserved cpu=200m,memory=512M --network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin >kubelet.log 2>&1  &
