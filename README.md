# cf_ha_chef Cookbook
##Note **This is a work in progress**

## Info
This cookbook will install and configure a high-availability Chef server cluster from our Cloudformation templates with two back end servers and and multiple front end servers.

This cookbook attempts to automate most of the steps in the installation guide. Official installation documentation is here: [https://docs.chef.io/install_server_ha_aws.html](https://docs.chef.io/install_server_ha_aws.html)

The front end servers and secondary back end server need configs that are generated on the primary back end machine. We work around this in the primary recipe by creating a *.tar.gz bundle for each of the core server and reporting configs, and then serving them up on a lightweight web server on port 31337. The 'cluster' recipe will try to pull this file for about 30 minutes before giving up. This means you can bring up the entire cluster in parallel, and the front ends and secondary back end machine will simply wait until the primary back end is ready before finishing their Chef run. You may use Chef Zero or Chef Provisioning to deploy your cluster.

The push_jobs, reporting, and manage UI plugins are all installed automatically. You should only need to call these three recipes directly:

frontend - for your front end servers

failover - for the failover back end server

primary - for the primary back end server

analytics - for the analytics server

## Requirements
Must use [cloudformation-chef-ha](https://github.com/HearstAT/cloudformation-chef-ha) Cloudformation to utilize this cookbook.

## Attributes
Insert Template Info Here

## Usage
Insert CF template info here

## Post Install
Due to limitation in chef and cloudformation both, there are some items that cannot be automated completely. Below are the steps that are needed taken post-cloudformation success.
- Backend Primary - run the following command from an interactive terminal (e.g.; ssh into server)
  - `chef-client -c '/root/.chef/cookbooks/client.rb' -z --chef-zero-port 8899 -j '/root/.chef/cookbooks/primary_post.json'`

- Analytics Server - run the following command from an interactive terminal (e.g.; ssh into server)
  - `chef-client -c '/root/.chef/cookbooks/client.rb' -z --chef-zero-port 8899 -j '/root/.chef/cookbooks/analytics_post.json'`

- All other servers - run the following command from an interactive terminal (e.g.; ssh into server)
  - `chef-client -c '/root/.chef/cookbooks/client.rb' -z --chef-zero-port 8899 -j '/root/.chef/cookbooks/post_install.json'`

## Sample IAM Account Settings
The HA Chef Setup requires a IAM account with the following setup. The CF Templates will create this.

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1419361552000",
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:CreateTags",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeVolumes",
        "ec2:DescribeInstances",
        "ec2:DetachVolume",
        "ec2:EnableVolumeIO",
        "ec2:ImportVolume",
        "ec2:ModifyVolumeAttribute",
        "ec2:DescribeNetworkInterfaces",
        "ec2:AssignPrivateIpAddresses",
        "ec2:UnassignPrivateIpAddresses"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```
