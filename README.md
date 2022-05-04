Simple example to customize vm by terraform to use with yandex cloud
=========

Short info
------------

Tested on Ubuntu 20.04

You need to enter 
1) Virtual machine CPU cores number (vm_cpu_cores)
2) Virtual machine name (vm_name)
3) Virtual machine RAM GB number (vm_ram)

Additional packages are required (including terraform):

```
apt update && apt install -y git
```
Terraform installation:
https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

YC CLI install:
```
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

YC init to initialize your profile with token:
```
yc init
```
Follow YC manual: https://cloud.yandex.ru/docs/cli/quickstart

Clone repository:

```
git clone https://github.com/sk0ld/terraform-ycloud-template.git
cd terraform-ycloud-template
```

To create file with your IDs (inside project directory):
```
touch wp.auto.tfvars
```
Example of content wp.auto.tfvars:
```
folder_id = "your_folder_id"
sa_id = "your_sa_id"
cloud_id = "your_cloud_id"
token = "your_token"
```

Settings for terraform:
```
touch ~/.terraformrc
```
Content of .terraformrc:
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

To prepare configuration (inside the directory with *.tf):
```
terraform init
terraform plan
terraform apply
```

Apply without confirmation:
```
terraform apply --auto-approve
```

To delete all the created instances:

```
terraform destroy
```

To delete all without confirmation:
```
terraform destroy --auto-approve
```

Requirements
------------

Create additional virtual directory in Yandex Cloud. 
There is directory with name tf-dir for current example.
Delete all networks inside directory or contact YC support to extend quantity of networks.


Static key for service account:
https://github.com/yandex-cloud/docs/blob/master/en/iam/operations/sa/create-access-key.md



ssh keys and additional configs:
-----------------------------

Generate and put private and public ssh keys for your VMs here:
```
/home/your_user/.private_yc
```

To create user metadata (for example for user pcadm):
```
touch /home/your_user/meta.txt
```

Content of meta.txt :
```
#cloud-config
users:
  - name: pcadm
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
      ssh-authorized-keys:
      - ssh-rsa AAAAB3Nza......OjbSMRX pcadm@vm-ubuntu210
```

