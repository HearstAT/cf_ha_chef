#
# Cookbook Name:: cf_ha_chef
# Default Attributes File
#
# Copyright 2016, Hearst Automation Team
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Pass to pull a backup and use knife ec to restore
default['cf_ha_chef']['backup']['restore'] = false
default['cf_ha_chef']['backup']['enable_backups'] = false
default['cf_ha_chef']['backup']['restore_file'] = ''

# S3 Bucket mount location accomplished during CFN
default['cf_ha_chef']['s3']['dir'] = ''

# Manage Attributes
default['cf_ha_chef']['manage']['signupdisable'] = ''
default['cf_ha_chef']['manage']['supportemail'] = ''

# Mail Relay host
default['cf_ha_chef']['mail']['relayhost'] = ''
default['cf_ha_chef']['mail']['relayport'] = ''

# License Count Info
default['cf_ha_chef']['licensecount'] = '25'

# FQDN of your Amazon Elastic Load Balancer or Route53 CNAME to load balancer DNS
default['cf_ha_chef']['api_fqdn'] = ''

# EBS storage device for backend
default['cf_ha_chef']['ebs_volume_id'] = ''
default['cf_ha_chef']['ebs_device'] = ''

# Domain provided via Route53 hosted zone
default['cf_ha_chef']['domain'] = ''

# Database Config
default['cf_ha_chef']['database']['ext_enable'] = ''
default['cf_ha_chef']['database']['port'] = ''
default['cf_ha_chef']['database']['url'] = ''

# Cookbook Config
default['cf_ha_chef']['cookbook']['ext_enable'] = ''
default['cf_ha_chef']['cookbook']['bucket'] = ''

# Analytic Server Config
default['cf_ha_chef']['analytics']['stage_subdomain'] = ''
default['cf_ha_chef']['analytics']['url'] = ''
default['cf_ha_chef']['analytics']['fqdn'] = ''
default['cf_ha_chef']['analytics']['ip_address'] = ''

# Backend Attributes
default['cf_ha_chef']['backendprimary']['fqdn']        = ''
default['cf_ha_chef']['backendprimary']['ip_address']  = ''
default['cf_ha_chef']['backendfailover']['fqdn']       = ''
default['cf_ha_chef']['backendfailover']['ip_address'] = ''

# Shared VIP address for the backend servers, needs to be known by all servers
default['cf_ha_chef']['backend_vip']['fqdn']       = ''
default['cf_ha_chef']['backend_vip']['ip_address'] = ''

# Frontend Attributes
default['cf_ha_chef']['frontends']['fe1']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe1']['ip_address']    = ''

# Frontend Attributes
default['cf_ha_chef']['frontends']['fe2']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe2']['ip_address']    = ''

# Citadel
default['citadel']['bucket'] = ''
default['sumologic']['userID'] = ''

# Newrelic
default['cf_ha_chef']['newrelic']['enable'] = true
default['cf_ha_chef']['newrelic']['appname'] = ''

# Sumologic
default['cf_ha_chef']['sumologic']['enable'] = true
