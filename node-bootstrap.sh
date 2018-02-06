#!/bin/bash 

array=('kube-proxy' 'kubelet')
for data in ${array[@]}
do
    pid=$(ps -aux | grep ${data} | grep -v grep | awk '{print $2}')

    echo "$data  pid $pid  "
    if [ -n "$pid" ]; then
        kill $pid
        echo "kill $data"
    fi
done


./kubelet --logtostderr=true --v=4 --address=192.168.111.93 --node-ip=192.168.111.93 --hostname-override=hzc-slave1 --allow-privileged=true --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --require-kubeconfig --authorization-mode=Webhook --client-ca-file=/etc/kubernetes/ssl/ca.crt --pod-manifest-path=/etc/kubernetes/manifests --cadvisor-port=0 --pod-infra-container-image=hub.easystack.io/captain/pause-amd64:3.0 --kube-reserved cpu=100m,memory=256M --node-status-update-frequency=10s --cgroup-driver=cgroupfs --docker-disable-shared-pid=True --anonymous-auth=false --fail-swap-on=True --feature-gates=CustomPodDNS=true --cluster-dns=10.233.0.3 --cluster-domain=cluster.local --resolv-conf=/etc/resolv.conf --kube-reserved cpu=100m,memory=256M --network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin  >kubelet.log 2>&1 &


./kube-proxy --config=/var/lib/kube-proxy/config.conf   >proxy.log 2>&1  &

