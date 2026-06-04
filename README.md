# python_flask_app_cd
devops demo


## Usage

## the best advice is you can install EBS CSI controller by Terraform

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
- Cleanup the pod resource
```shell
 kubectl scale deployment todo-app-todo-app-web -n todo-app --replicas=0
 ```

## Resources Usage Minitor

- Check how much memory the pod cost 
```shell
allen@192 aws_terraform_eks_karpenter % kubectl top pods -n todo-app
NAME                                     CPU(cores)   MEMORY(bytes)   
todo-app-todo-app-mysql-0                7m           389Mi           
todo-app-todo-app-web-786cccf8b5-9m74m   1m           51Mi            
todo-app-todo-app-web-786cccf8b5-j8xq5   1m           51Mi            


```
- Check how much memory the nodes cost
```shell
allen@192 aws_terraform_eks_karpenter % kubectl top nodes
NAME                          CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
ip-10-0-11-23.ec2.internal    57m          2%       1179Mi          82%         
ip-10-0-11-245.ec2.internal   54m          2%       882Mi           61%         
ip-10-0-12-149.ec2.internal   35m          1%       662Mi           46%         
ip-10-0-13-193.ec2.internal   46m          2%       842Mi           58%         

```
- check the ALB for web access 
```shell
allen@192 aws_terraform_eks_karpenter % kubectl get svc -n todo-app
NAME                            TYPE           CLUSTER-IP       EXTERNAL-IP                                                              PORT(S)        AGE
todo-app-todo-app-mysql         ClusterIP      172.20.204.189   <none>                                                                   3306/TCP       5h45m
todo-app-todo-app-web-service   LoadBalancer   172.20.19.137    a0bfc4576fd304708bf0e79d95a44c55-484253965.us-east-1.elb.amazonaws.com   80:31792/TCP   5h45m
```




