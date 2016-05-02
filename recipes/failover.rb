#
# Cookbook Name:: cf_ha_chef
# Recipe:: secondary
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

package 'chef-ha'
package 'chef-server-core'

template '/etc/hosts' do
  action :create
  source 'failover_hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'cf_ha_chef::disable_iptables'
include_recipe 'cf_ha_chef::server_install'
include_recipe 'cf_ha_chef::backup'

# Make sure we have LVM installed in case of failover
package 'lvm2' do
  action :install
end

# Create missing keepalived cluster status files
directory '/var/opt/opscode/keepalived' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

file '/var/opt/opscode/keepalived/current_cluster_status' do
  action :create
  content 'backup'
  owner 'root'
  group 'root'
  mode '0644'
end

file '/var/opt/opscode/keepalived/requested_cluster_status' do
  action :create
  content 'backup'
  owner 'root'
  group 'root'
  mode '0644'
end
