# terraform_private_vagrant_cloud

Running this code will create webserver in AWS configured to serve as vagrant cloud for your boxes

## Requirements
- Terraform installed. Click [here](https://learn.hashicorp.com/terraform/getting-started/install.html) to install
- AWS account
  - If you do not have AWS account click [here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) in order to create one.
  - Set [MFA](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication)
  - Set [Access Key ID and Secret Access Key ](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
  - Set [Key Pair](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#key-pairs)

## Repo content
| File                   | Description                      |
|         ---            |                ---               |
| assets | directory for boxes (not needed to run this project) |
| conf| contain configuration file needed for nginx and versioning json file |
| example | example can be used independently - this is how to run this project as a module |
| scripts/provision.sh | our installation script |
| main.tf | terraform main code file |
| output.tf | DNS public output for AWS |
| vars.tf | all needed terraform variables |

## How to run this project?
- Clone repo: `git clone https://github.com/berchev/terraform_private_vagrant_cloud.git`
- Change to **terraform_private_vagrant_cloud**: `cd terraform_private_vagrant_cloud`
- Create file **terraform.tfvars** like this:
    ```
    aws_access_key = "XXXXXXXXXXXXXXXXXXXX"
    aws_secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    region = "your_region"
    ami = "your_ami"
    instance_type = "selected_instance_type"
    ssh_key_name = "name_of your_key_pair_without_.pem"
    private_key = "full_path_to_your_private_key"
    ```
- Now you are ready for terraform part:
    ``` 
    terraform init
    terraform plan
    terraform apply
    ```
- Once execution finish you will see output very similar to this one:
```
    Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

    Outputs:

    pulic_dns = ec2-54-191-171-2.us-west-2.compute.amazonaws.com
```
- Test whether following URL can be open: `http://ec2-54-191-171-2.us-west-2.compute.amazonaws.com/vagrant/xenial64`, do not forget to substitute **ec2-54-191-171-2.us-west-2.compute.amazonaws.com** with output from your terraform run.
- Testing above address in your browser, will return JSON versioning catalog.

If everything above is working, you may proceed to the next steps
- On your local machine export ENV variable **VAGRANT_SERVER_URL**: `export VAGRANT_SERVER_URL="http://ec2-54-191-171-2.us-west-2.compute.amazonaws.com"`, do not forget to substitute **ec2-54-191-171-2.us-west-2.compute.amazonaws.com** with output from your terraform run
- Change to home: `cd $HOME`
- type: `vagrant init -m vagrant/xenial64`, which will place to your current directory Vagrantfile with minimum configuration
- type: `vagrant up` , in order to use the box provided by your cloud webserver

# TODO
- Kitchen test - box json should return 200



