## Description
example/ folder is separate project. The idea is to use [root repo content](https://github.com/berchev/terraform_private_vagrant_cloud) as a module

## Example project content
| File                   | Description                      |
|         ---            |                ---               |
| test/integration/default | Default directory path, where kitchen test files are placed |
| .kitchen.yml | Kitchen configuration file |
| Gemfile | Contain all gems required for the kitchen test |
| main.tf | terraform main configuration file. Contain path to the module and needed variables |
| outputs.tf | terraform output after terraform apply |
| vars.tf | terraform variables |

## Requirements
- Terraform installed. Click [here](https://learn.hashicorp.com/terraform/getting-started/install.html) to install
- Kitchen testing framework (if not installed, do below steps)
  - Type in terminal: `sudo apt-get install -y rbenv ruby-dev ruby-bundler`
  - Add this to your ~/.bash_profile:
  ```
  eval "$(rbenv init -)"
  true
  export PATH="$HOME/.rbenv/bin:$PATH"
  ```
  - Type in terminal: `. ~/.bash_profile` in order to apply the changes made in .bash_profile
- AWS account
  - If you do not have AWS account click [here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) in order to create one.
  - Set [MFA](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#multi-factor-authentication)
  - Set [Access Key ID and Secret Access Key ](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)
  - Set [Key Pair](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#key-pairs)

## Instructions
- **Terraform part**
  - Clone repo: `git clone https://github.com/berchev/terraform_private_vagrant_cloud.git`
  - Change to **terraform_private_vagrant_cloud/example**: `cd terraform_private_vagrant_cloud/example`
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
  - Now you are ready for terraform deploy:
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

- **Kitchen part**
  - Make sure you are into **example** directory 
  - Make sure your Ruby version is the same, like Ruby version into Gemfile
  - To check your Ruby version type: `ruby --version`
  - If needed edit Gemfile
  - Type: `bundle install --path vendor/bundle` in order to install all needed gems for the test in your current directory
  - Note that Kitchen tool use for authentication **terraform.tfvars** file, created in **Terraform part**
  - Edit ssh_key field with ~/path/to/your/private/aws/key.pem in **.kitchen.yml** file
  - Type: `bundle exec kitchen converge` to build environment with kitchen based on .kitchen.yml file
  - Type: `bundle exec kitchen list` and you should notice that environment is created
  - Type: `bundle exec kitchen verify` to test the created kitchen environment based on the tests in test/integration/default directory
  - If everything is OK, you should see output very similar to the one below:
  ```
  Profile: default
  Version: (not specified)
  Target:  ssh://ubuntu@ec2-52-25-179-20.us-west-2.compute.amazonaws.com:22

    ✔  operating_system: Command: `lsb_release -a`
       ✔  Command: `lsb_release -a` stdout should match /Ubuntu/
       ✔  System Package nginx should be installed
       ✔  File /etc/nginx/sites-available/localhost should exist
    ✔  check_json: HTTP GET on http://ec2-52-25-179-20.us-west-2.compute.amazonaws.com/vagrant/xenial64/
       ✔  HTTP GET on http://ec2-52-25-179-20.us-west-2.compute.amazonaws.com/vagrant/xenial64/ status should cmp == 200


  Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
  Test Summary: 4 successful, 0 failures, 0 skipped
         Finished verifying <default-ubuntu> (0m11.09s).
  -----> Kitchen is finished. (0m12.35s)

  ``` 
  - Type: `bundle exec kitchen destroy` in order to destroy the created kitchen environmen

## Conclusion
For any questions or request, please feel free to open an issue
All instruction provided above are tested with OS Ubuntu 18.04

## TODO
- [x] example/ directory to work as separate project (use module)
- [x] Kitchen test of example/ project
- [x] README with instructions



