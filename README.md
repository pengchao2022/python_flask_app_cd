# python_flask_app_cd
devops demo


## Usage

- Install eksctl
```shell
brew install eksctl
```

- Create IAM role allow EKS to manager EBS driver
```shell
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster allen-eks-karpenter \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve
```

- Install EBS CSI controller on EKS
```shell
eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster allen-eks-karpenter \
  --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole \
  --force
  ```

- Check the EBS CSI controller pod
```shell
  allen@192 argocd % kubectl get pods -n kube-system | grep ebs
ebs-csi-controller-657578f657-98m7q   6/6     Running   0          57s
ebs-csi-controller-657578f657-zqmb4   6/6     Running   0          57s
ebs-csi-node-2kp28                    3/3     Running   0          57s
ebs-csi-node-57tgs                    3/3     Running   0          57s
ebs-csi-node-l9fsd                    3/3     Running   0          57s
ebs-csi-node-ns5qq                    3/3     Running   0          57s
ebs-csi-node-xjps7                    3/3     Running   0          57s
```

- Delete old stuck PVC
```shell
kubectl delete pvc todo-app-todo-app-mysql-pvc -n todo-app
```

- Delete old pending pod
```shell
kubectl delete pod todo-app-todo-app-mysql-74698d88cf-6m45l -n todo-app
```
