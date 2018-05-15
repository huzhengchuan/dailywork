package main

import (
	"fmt"
	"os"
	"k8s.io/kubernetes/staging/src/k8s.io/client-go/rest"
	"k8s.io/kubernetes/staging/src/k8s.io/client-go/tools/clientcmd"
	"k8s.io/kubernetes/staging/src/k8s.io/client-go/kubernetes"
	meta_v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)
/*
	example to access kubernetes cluster
*/
const (
	MASTER_URL string = "MASTER_URL"
	KUBE_CONFIG string = "KUBE_CONFIG"
)


func main() {

	masterUrl := os.Getenv(MASTER_URL)
	kubeConfig := os.Getenv(KUBE_CONFIG)

	var config *rest.Config
	var err error
	if masterUrl == "" || kubeConfig == "" {
		config, err := rest.InClusterConfig()
	}else {
		config, err := clientcmd.BuildConfigFromFlags(masterUrl, kubeConfig)
	}

	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil{
		panic(err.Error())
	}

	pods, err := clientset.CoreV1().Pods("").List(meta_v1.ListOptions{})
	if err != nil {
		panic(err.Error())
	}
	fmt.Printf("There are %d pods in the cluster\n", len(pods.items))

	for index, value := range pods {
		fmt.Println(value)
	}
}
