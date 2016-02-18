#
# Cookbook Name:: cf_ha_chef
# Recipe:: analytics
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
# This recipe installs the analytics server.

include_recipe 'cf_ha_chef::hosts'
include_recipe 'cf_ha_chef::disable_iptables'
include_recipe 'cf_ha_chef::mail'

# Create and place the analytics configuration file

directory '/etc/opscode-analytics' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/opscode-analytics/opscode-analytics.rb' do
  action :create
  source 'opscode-analytics.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Ensure cert directory exists
directory '/var/opt/opscode-analytics/ssl/ca/' do
  owner 'root'
  group 'root'
  mode 00644
  recursive true
  action :create
end

directory '/var/opt/opscode-analytics/nginx/etc/nginx.d/' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

# Put the wildcard cert into place for nginx

cookbook_file "/var/opt/opscode-analytics/ssl/ca/chef-analytics.#{node['cf_ha_chef']['domain']}.crt" do
  source "#{node['cf_ha_chef']['domain']}.crt"
  owner 'root'
  group 'root'
  mode 00644
end

cookbook_file "/var/opt/opscode-analytics/ssl/ca/chef-analytics.#{node['cf_ha_chef']['domain']}.key" do
  source "#{node['cf_ha_chef']['domain']}.key"
  owner 'root'
  group 'root'
  mode 00644
end
