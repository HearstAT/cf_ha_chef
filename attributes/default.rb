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

# Secrets Holder
default['cf_ha_chef']['aws_secret_access_key'] = ''
default['cf_ha_chef']['aws_access_key_id'] = ''

# SASL S3 Bucket
default['cf_ha_chef']['sasl_location'] = ''

# Manage Attributes
default['cf_ha_chef']['manage']['signupdisable'] = 'false'
default['cf_ha_chef']['manage']['cheflog_level'] = 'info'
default['cf_ha_chef']['manage']['managelog_level'] = 'info'
default['cf_ha_chef']['manage']['publicport'] = '443'
default['cf_ha_chef']['manage']['supportemail'] = 'chefsupport@domain.com'

# Mail Relay host
default['cf_ha_chef']['mail']['relayhost'] = 'smtp.domain.com'
default['cf_ha_chef']['mail']['relayport'] = '25'

# License Count Info, still unsure if this works
default['cf_ha_chef']['licensecount'] = '25'

# FQDN of your Amazon Elastic Load Balancer or Route53 CNAME to load balancer DNS
default['cf_ha_chef']['api_fqdn'] = ''

# EBS storage device for backend
default['cf_ha_chef']['ebs_volume_id'] = ''
default['cf_ha_chef']['ebs_device'] = ''

# Set domain up
default['cf_ha_chef']['domain'] = 'chef.domain.com'

# Analytic Server Config needed by all servers
default['cf_ha_chef']['analytics']['url'] = 'analytics.domain.com'

# Only needs to be known to the analytics server itself
default['cf_ha_chef']['analytics']['fqdn'] = ''
default['cf_ha_chef']['analytics']['ip_address'] = ''

# Backend servers.  Must be in same availability zone, for example: us-west-1b, needs to be known by all servers excluding analytics
default['cf_ha_chef']['backendprimary']['fqdn']        = ''
default['cf_ha_chef']['backendprimary']['ip_address']  = ''
default['cf_ha_chef']['backendfailover']['fqdn']       = ''
default['cf_ha_chef']['backendfailover']['ip_address'] = ''

# Shared VIP address for the backend servers, needs to be known by all servers
default['cf_ha_chef']['backend_vip']['fqdn']       = ''
default['cf_ha_chef']['backend_vip']['ip_address'] = ''

# Put your frontends in different availability zones if you wish
# Only FE01 needs to know about FE01, frontends don't need to know about each other and the backend doesn't need to know about the frontends.
# The 172.33.2.0/24 subnet is in us-west-1b
default['cf_ha_chef']['frontends']['fe1']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe1']['ip_address']    = ''
# The 172.33.2.0/24 subnet is in us-west-1b
default['cf_ha_chef']['frontends']['fe2']['fqdn']          = ''
default['cf_ha_chef']['frontends']['fe2']['ip_address']    = ''
