
### Install Packer 
https://learn.hashicorp.com/tutorials/packer/get-started-install-cli?in=packer/aws-get-started
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```
To verify installation just type __packer__ in the terminal

```bash
packer
Usage: packer [--version] [--help] <command> [<args>]

Available commands are:
    build           build image(s) from template
    console         creates a console for testing variable interpolation
    fix             fixes templates from old versions of packer
    fmt             Rewrites HCL2 config files to canonical format
    hcl2_upgrade    transform a JSON template into an HCL2 configuration
    init            Install missing plugins or upgrade plugins
    inspect         see components of a template
    validate        check that a template is valid
    version         Prints the Packer version
```

### Working with Packer
The Packer builds images by using the provided __.hcl__ or __.json__ dodcument. For this tutorial we are going to use the former.
To start, create the directory where you will work and navigate into it
```bash
mkdir packer_dir
cd packer_dir
```
Place the provide __aws-ubuntu.pkr.hcl__ document inside of it
The document contains multiple blocks, here is the brief description of each

1. __packer__ block contains the information about the version of Packer to use as well as the plugins needed to create the image in the __required_plugins__ section. In this case the plugin we need is __amazon__ . Some of these plugins, like the Amazon AMI Builder (AMI builder) which you will to use, are built, maintained, and distributed by HashiCorp — but anyone can write and use plugins.

2. __variable__ block contains the variable definition. In this case, the variables are used for AMI name. There are multiple ways to assign variables which include variable file(s) and command-line flag. It will be shown in the later part of the tutorial

3. __source__ block configures a specific builder plugin, which is then invoked by a build block. A source block has two important labels: a builder type and a name. These two labels together will allow us to uniquely reference sources later on when we define build runs. In the example template, the builder type is __amazon-ebs__ and the name is __ubuntu__.  We declare the name of the created AMI using the previously declared variables, the region and the instance type which will be used during the building process. __launch_block_device_mappings__ is used to either modify or to add additional volume mounts to the instance. In this case we modify the root volume to have the size of 500 GB. __source_ami_filter__ is used to specify the base AMI used for creation of custom AMI (https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeImages.html). 


4. __build__ block defines what Packer should do with the EC2 instance after it launches. In the example template, the build block references the AMI defined by the source block above __source.amazon-ebs.ubuntu__. It also contains the __provisioner__ section, which describes the instruction needed to be executed during the building of AMI. In our case, these are stored in the __install_conda.sh__, __update_conda.sh__ and __install_docker.sh__.

Before you can build the AMI, you need to provide your AWS credentials to Packer as environment environments. These credentials have permissions to create, modify and delete EC2 instances. Refer to the documentation to find the full list IAM permissions required to run the amazon-ebs builder (https://www.packer.io/docs/builders/amazon#iam-task-or-instance-role). Add your AWS credentials as two environment variables, AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, replacing YOUR_ACCESS_KEY and YOUR_SECRET_KEY with their respective values.

```bash
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
```

Now you need to initialize Packer configuration

```bash
packer init .
```
This command will download all the plugins needed for image creation.
Format your configuration and validate it

```bash
packer fmt .
packer validate .
```
Now you can finally build the AMI 

```bash
packer build aws-ubuntu.pkr.hcl
```