# Introduction
This tool is developed based on Terraform. You can deploy and manage your k8s environment which is construct by below components to test your stateful applications.
- AWS EKS cluster
- AWS FSx for NetAPP ONTAP filesystems and storage virtual machines
- Astra Trident(CSI plug-in to use FSxN as persistent storage of EKS) 

**Note that this tool is not intended to use for production envirnoment.**

# Prerequisite
## Workstation requirement
- Terraform
- AWS CLI
- helm3

## AWS requirement
- existing VPC
- existing subnet(s)
- IAM user to deploy and manage ESK, FSxN, and S3 bucket
  - also you need to get access keys of this IAM user and do "aws configure" in your workstation. see [AWS documentation](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds).

# How to use
##  Initial setup
Before deploying your first environment, you need to perform following steps

1. Create a S3 bucket to store your tfstate at deploying step
```sh
# set your s3 bucket name that will be created following step
$ export S3BUCKET=<YOUR_S3_BUCKET_NAME>

# update .tf file with your S3 bucket name
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/s3bucket/variables.tf 

# Create your S3 bucket
$ terraform init
$ terraform plan
$ terraform apply
```

2. Update .tf files with your S3 bucket name
```sh
$ cd "$(git rev-parse --show-toplevel)"
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/eks/backend.tf 
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/fsxn/backend.tf
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/trident-install/backend.tf
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/trident-install/variables.tf
$ sed -i -e "s/remote-tf-20221019/${S3BUCKET}/g" environments/trident-configure/variables.tf
```

## Deploying your environment
You can perform not only entire deployment but also partial deployment.
For example, if you already have you k8s cluster and just need backend storage for statefull applications, you can just perform [FSxN deployment](#aws-fsx-for-netapp-ontap) and [Trident deployment](#astra-trident).

### AWS EKS cluster
You can deploy FSxN as following steps in parallel with these steps

1. Edit variables.tf to customize your EKS cluster(i.e. cluster name, k8s version, subnets, etc)
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/eks
$ vi variables.tf
```

2. Review and apply your EKS cluster(It takes about 15min)
```sh
# Dry-run terraforming
$ terraform plan

# Execute terraforming
$ terraform apply
~~~
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

cluster_name = "cluster1"
endpoint = "https://xxxxxx.xxxxx.ap-northeast-1.eks.amazonaws.com"
kubeconfig-certificate-authority-data = "xxxxxxxxx"
kubectl_config = <<EOT
apiVersion: v1
clusters:
- cluster:
    server: "https://xxxxxxxx.xxxxxx.ap-northeast-1.eks.amazonaws.com"
    certificate-authority-data: "xxxxxxxxxxx"
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
      - eks
      - get-token
      - --cluster-name
      - "cluster1"

EOT
token = <sensitive>
```

3. Create kubeconfig from stdout of "terraform apply"
```sh
# copy and pasete "kubectl_config" from previous output
$ vi ~/.kube/config

# verify your kubeconfig
$ kubectl get node
```

### AWS FSx for NetApp ONTAP
You can deploy EKS cluster as previous steps in parallel with these steps

1. Edit variables.tf to customize your FSxN filesytem(i.e. subnets, admin password, etc)
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/fsxn
$ vi variables.tf
```

2. Review and apply your FSxN(It takes about 45min)
```sh
# Dry-run terraforming
$ terraform plan

# Execute terraforming
$ terraform apply
~~~
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

admin_password = "P@ssw0rd"
management_dns_name = "management.fs-xxxxxxx.fsx.ap-northeast-1.amazonaws.com"
svm_name = "svm1"
```


### Astra Trident
You can NOT deploy Astra Trident instances in parallel with EKS clusters nor FSxN instances

1. Download your target version of Astra Trident's helm chart from [GitHub repository](https://github.com/NetApp/trident/releases) and place it assets directory
```sh
# Downlaod the installer archive (replace URL with your target version)
$ cd "$(git rev-parse --show-toplevel)"
$ wget https://github.com/NetApp/trident/releases/download/v22.07.0/trident-installer-22.07.0.tar.gz

# extract the installer archive
$ tar -xvf trident-installer-22.07.0.tar.gz

# move helm chart to assets directory
$ mv trident-installer/helm/trident-operator-22.07.0.tgz assets/
```

2. (Option)Edit variables.tf to customize your Trident instance(i.e. path to the helm chart, storageClass name, etc)
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/trident-install
$ vi variables.tf
```

3. install Astra Trident instance into your EKS cluster
```sh
# Dry-run terraforming
$ terraform plan

# Execute terraforming
$ terraform apply
~~~
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

trident_namespace = "trident"
```

4. Verify that your Trident instance has been successfully deployed(it takes a few minitues after the helm chart has been deployed)
```sh
$ kubectl get pod -n trident
NAME                                READY   STATUS    RESTARTS   AGE
trident-csi-5cb56b8b48-xhbdh        6/6     Running   0          93s
trident-csi-lx5dj                   2/2     Running   0          93s
trident-csi-wxs9m                   2/2     Running   0          93s
trident-operator-66cd859976-s9l2j   1/1     Running   0          119s
```

4. (Option)Edit variables.tf to customize your Trident configs(i.e. tridentBackend name, storageClass name, etc)
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/trident-configure
$ vi variables.tf
```

5. Configure Astra Trident


```sh
# Dry-run terraforming
$ terraform plan

# Execute terraforming
$ terraform apply
~~~
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

Note that showing this warning message is expected behaivors. You can ignore and proceed to applying step.
```
│ Warning: This custom resource does not have an associated OpenAPI schema.
│ 
│   with module.trident_configure.kubernetes_manifest.trident_backend_config,
│   on ../../modules/trident-configure/main.tf line 28, in resource "kubernetes_manifest" "trident_backend_config":
│   28: resource "kubernetes_manifest" "trident_backend_config" {
│ 
│ We could not find an OpenAPI schema for this custom resource. Updates to this resource will cause a forced replacement.
```

## Testing stateful applications in your environment
Now you can deploy and test stateful applications whatever you want with your EKS cluster. Here is a sample deployment with wordpress application.
```sh
# check your trident storageclass name
$ kubectl get sc
NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
fsxn-nas-sc     csi.trident.netapp.io   Delete          Immediate              true                   17h
gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  19h

# add helm repository of wordpress
$ helm repo add bitnami https://charts.bitnami.com/bitnami
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: ./kubeconfig
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: ./kubeconfig
"bitnami" has been added to your repositories

# install helm chart of wordpress with your storageclass 
$ helm install mt-wordpress bitnami/wordpress --set global.storageClass=<YOUR_STORAGECLASS_NAME>
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: ./kubeconfig
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: ./kubeconfig
NAME: mt-wordpress
LAST DEPLOYED: Fri Oct 21 02:11:29 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: wordpress
CHART VERSION: 15.2.6
APP VERSION: 6.0.3

# verify that PVs has been successfully provisioned via storageclass you've checked previous step
$ kubectl get pvc
NAME                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-mt-wordpress-mariadb-0   Bound    pvc-5cfdc86c-5336-4a0c-9797-6b98778de7c1   8Gi        RWO            fsxn-nas-sc    52s
mt-wordpress                  Bound    pvc-e569b9ac-4407-4e79-b8f6-b37c6544c9a5   10Gi       RWO            fsxn-nas-sc    52s
```


## Deleting your environment

### Deleting your ESK cluster
1. Destroy your EKS cluster with terraform
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/eks
$ terraform destroy
```

### Deleting your fsxn filesystem
1. Delete all of your volumes on FSxN filesystem other than SVM root volume.

2. Destroy your FSxN filesystem and SVM with terraform
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/fsxn
$ terraform destroy
```

### Deleting your s3bucket
You can keep remain s3 bucket to use again next deployment.

1. Destroy your s3 bucket with terraform
```sh
$ cd "$(git rev-parse --show-toplevel)"/environments/s3bucket
$ terraform destroy
```
