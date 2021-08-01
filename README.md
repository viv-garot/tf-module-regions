# sample repo - create 1 module, use module twice and set modules in different regions

## Description
Create a module, create code using this module twice (in different regions).
Here we'll create a security group in Frankfurt and Stockholm

## Pre-requirements

* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 
* [Terraform cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [AWS account and AWS Access Credentials](https://aws.amazon.com/account/)

## How to use this repo

- Clone
- Run
- Cleanup

---

### Clone the repo

```
git clone https://github.com/viv-garot/tf-module-regions
```

### Change directory

```
cd tf-module-regions
```

### Run

* Init:

```
terraform init
```

_sample_:

```
terraform init
Initializing modules...
Downloading github.com/viv-garot/sg-aws for ec2-instance-central...
- ec2-instance-central in .terraform/modules/ec2-instance-central
Downloading github.com/viv-garot/sg-aws for ec2-instance-north...
- ec2-instance-north in .terraform/modules/ec2-instance-north

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Installing hashicorp/aws v3.52.0...
- Installed hashicorp/aws v3.52.0 (signed by HashiCorp)

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

* Apply:

```
terraform apply
```

_sample_:

```
terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.ec2-instance-central.aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # module.ec2-instance-north.aws_security_group.instance will be created
  + resource "aws_security_group" "instance" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 8080
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 8080
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + central-sg-id = (known after apply)
  + north-sg-id   = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.ec2-instance-north.aws_security_group.instance: Creating...
module.ec2-instance-central.aws_security_group.instance: Creating...
module.ec2-instance-central.aws_security_group.instance: Creation complete after 2s [id=sg-0bbc1232acab19881]
module.ec2-instance-north.aws_security_group.instance: Creation complete after 2s [id=sg-036698a475b097f55]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

central-sg-id = "sg-0bbc1232acab19881"
north-sg-id = "sg-036698a475b097f55"
```

* Confirm the SGs have been created

```
aws ec2 describe-security-groups --filter --group-ids $(terraform output -raw central-sg-id) --region=eu-central-1
aws ec2 describe-security-groups --filter --group-ids $(terraform output -raw north-sg-id) --region=eu-north-1
```

_sample_:

```
aws ec2 describe-security-groups --filter --group-ids $(terraform output -raw central-sg-id) --region=eu-central-1
{
    "SecurityGroups": [
        {
            "Description": "Managed by Terraform",
            "GroupName": "terraform-20210801204942045000000001",
            "IpPermissions": [
                {
                    "FromPort": 8080,
                    "IpProtocol": "tcp",
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "ToPort": 8080,
                    "UserIdGroupPairs": []
                }
            ],
            "OwnerId": "267023797923",
            "GroupId": "sg-0bbc1232acab19881",
            "IpPermissionsEgress": [],
            "VpcId": "vpc-dbd777b1"
        }
    ]
}

aws ec2 describe-security-groups --filter --group-ids $(terraform output -raw north-sg-id) --region=eu-north-1
{
    "SecurityGroups": [
        {
            "Description": "Managed by Terraform",
            "GroupName": "terraform-20210801204942041300000001",
            "IpPermissions": [
                {
                    "FromPort": 8080,
                    "IpProtocol": "tcp",
                    "IpRanges": [
                        {
                            "CidrIp": "0.0.0.0/0"
                        }
                    ],
                    "Ipv6Ranges": [],
                    "PrefixListIds": [],
                    "ToPort": 8080,
                    "UserIdGroupPairs": []
                }
            ],
            "OwnerId": "267023797923",
            "GroupId": "sg-036698a475b097f55",
            "IpPermissionsEgress": [],
            "VpcId": "vpc-0ff75a66"
        }
    ]
}
```

### Cleanup

```
terraform destroy
```

_sample_:

```
terraform destroy
module.ec2-instance-north.aws_security_group.instance: Refreshing state... [id=sg-036698a475b097f55]
module.ec2-instance-central.aws_security_group.instance: Refreshing state... [id=sg-0bbc1232acab19881]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply":

  # module.ec2-instance-central.aws_security_group.instance has been changed
  ~ resource "aws_security_group" "instance" {
        id                     = "sg-0bbc1232acab19881"
        name                   = "terraform-20210801204942045000000001"
      + tags                   = {}
        # (9 unchanged attributes hidden)
    }
  # module.ec2-instance-north.aws_security_group.instance has been changed
  ~ resource "aws_security_group" "instance" {
        id                     = "sg-036698a475b097f55"
        name                   = "terraform-20210801204942041300000001"
      + tags                   = {}
        # (9 unchanged attributes hidden)
    }

Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include
actions to undo or respond to these changes.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # module.ec2-instance-central.aws_security_group.instance will be destroyed
  - resource "aws_security_group" "instance" {
      - arn                    = "arn:aws:ec2:eu-central-1:267023797923:security-group/sg-0bbc1232acab19881" -> null
      - description            = "Managed by Terraform" -> null
      - egress                 = [] -> null
      - id                     = "sg-0bbc1232acab19881" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 8080
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 8080
            },
        ] -> null
      - name                   = "terraform-20210801204942045000000001" -> null
      - name_prefix            = "terraform-" -> null
      - owner_id               = "267023797923" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {} -> null
      - tags_all               = {} -> null
      - vpc_id                 = "vpc-dbd777b1" -> null
    }

  # module.ec2-instance-north.aws_security_group.instance will be destroyed
  - resource "aws_security_group" "instance" {
      - arn                    = "arn:aws:ec2:eu-north-1:267023797923:security-group/sg-036698a475b097f55" -> null
      - description            = "Managed by Terraform" -> null
      - egress                 = [] -> null
      - id                     = "sg-036698a475b097f55" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = ""
              - from_port        = 8080
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 8080
            },
        ] -> null
      - name                   = "terraform-20210801204942041300000001" -> null
      - name_prefix            = "terraform-" -> null
      - owner_id               = "267023797923" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {} -> null
      - tags_all               = {} -> null
      - vpc_id                 = "vpc-0ff75a66" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  - central-sg-id = "sg-0bbc1232acab19881" -> null
  - north-sg-id   = "sg-036698a475b097f55" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.ec2-instance-north.aws_security_group.instance: Destroying... [id=sg-036698a475b097f55]
module.ec2-instance-central.aws_security_group.instance: Destroying... [id=sg-0bbc1232acab19881]
module.ec2-instance-central.aws_security_group.instance: Destruction complete after 1s
module.ec2-instance-north.aws_security_group.instance: Destruction complete after 1s

Destroy complete! Resources: 2 destroyed.
```
