# cf_ha_chef Cookbook

# IMPORTANT
Must use [cloudformation-chef-ha](https://github.com/HearstAT/cloudformation-chef-ha) Cloudformation to utilize this cookbook.

See the cloudformation counterpart [wiki](https://github.com/HearstAT/cloudformation-chef-ha/wiki) for more detailed info.

## Info
This cookbook will install and configure a high-availability Chef server cluster from our Cloudformation templates with two backend servers, two front end servers, and a stand alone analytics server.

This cookbook attempts to automate most of the steps in the installation guide. Official installation documentation is here: [https://docs.chef.io/install_server_ha_aws.html](https://docs.chef.io/install_server_ha_aws.html)

The front end servers and secondary back end server need configs that are generated on the primary back end machine. We work around this in the primary recipe by creating a `*.tar.gz` bundle for each of the core server and reporting configs, and then utilizing S3 to store all the created bundles then pull them down onto each server. This means you can bring up the entire cluster in parallel, and the front ends and secondary back end machine will simply wait until the primary back end is ready before finishing their Chef run.

The push_jobs, reporting, manage, and analytics are all installed automatically via the recipes.

frontend - for your front end servers

failover - for the failover back end server

primary - for the primary back end server

analytics - for the analytics server

## Attributes
```ruby
# Secrets Holder, provided via Cloudformation
default['cf_ha_chef']['aws_secret_access_key'] = ''
default['cf_ha_chef']['aws_access_key_id'] = ''

# True/False to pull a backup and use knife ec to restore
default['cf_ha_chef']['backup_restore'] = ''

# S3 Bucket created by Cloudformation
default['cf_ha_chef']['s3']['backup_bucket'] = ''

# Manage Attributes
default['cf_ha_chef']['manage']['signupdisable'] = ''
default['cf_ha_chef']['manage']['supportemail'] = ''

# Mail Relay host
default['cf_ha_chef']['mail']['relayhost'] = ''
default['cf_ha_chef']['mail']['relayport'] = ''

# License Count Info
default['cf_ha_chef']['licensecount'] = ''

# FQDN of your Amazon Elastic Load Balancer or Route53 CNAME to load balancer DNS
default['cf_ha_chef']['api_fqdn'] = ''

# EBS storage device for backend
default['cf_ha_chef']['ebs_volume_id'] = ''
default['cf_ha_chef']['ebs_device'] = ''

# Domain provided via Route53 hosted zone
default['cf_ha_chef']['domain'] = ''

# Analytic Server Config needed by all servers
default['cf_ha_chef']['analytics']['url'] = ''

# Only needs to be known to the analytics server itself
default['cf_ha_chef']['analytics']['fqdn'] = ''
default['cf_ha_chef']['analytics']['ip_address'] = ''

# Backend Servers Attributes
default['cf_ha_chef']['backendprimary']['fqdn']        = ''
default['cf_ha_chef']['backendprimary']['ip_address']  = ''
default['cf_ha_chef']['backendfailover']['fqdn']       = ''
default['cf_ha_chef']['backendfailover']['ip_address'] = ''

# Shared VIP address for the backend servers
default['cf_ha_chef']['backend_vip']['fqdn']       = ''
default['cf_ha_chef']['backend_vip']['ip_address'] = ''

# Front End Attributes

default['cf_ha_chef']['frontends']['fe1']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe1']['ip_address']    = ''
default['cf_ha_chef']['frontends']['fe2']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe2']['ip_address']    = ''

# New Relic configurations
default['newrelic']['plugins'] = []

# Citadel
default['citadel']['bucket'] = ''
default['sumologic']['userID'] = ''
```

## Usage
Start with the [cloudformation-chef-ha](https://github.com/HearstAT/cloudformation-chef-ha) templates, this gets pulled via that process.

## Post Install
Due to limitation in chef and cloudformation both, there are some items that cannot be automated completely. Below are the steps that are needed taken post-cloudformation success.
- The command that actually needs to be ran should be in the backend server outputs. However if it doesn't refer below.
- Backend Primary - run the following command from an interactive terminal (e.g.; ssh into server)
  - `chef-client -c '/root/.chef/cookbooks/client.rb' -z --chef-zero-port 8899 -j '/root/.chef/cookbooks/primary_post_restore.json'`


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
        "cloudformation:DescribeStackResource",
        "s3:GetObject",
        "s3:Put",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:List*",
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
## Thanks
A lot of this works is based off of [aws_ha_chef](https://github.com/scarolan/aws_ha_chef) by Sean Carolan (scarolan) I just did away with the ruby server and chef provisioning bits.

## Copyright & License

Copyright (C) 2016 Hearst Automation Team

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
