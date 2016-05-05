#
# Cookbook Name:: cf_ha_chef
# Recipe:: certs
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

node.default['cf_ha_chef']['certs']['domain_crt'] = citadel['certs/crt']

directory '/var/opt/opscode/nginx/ca' do
  owner 'root'
  group 'root'
  mode 00750
  recursive true
  action :create
end

file "/var/opt/opscode/nginx/ca/chef.#{node['cf_ha_chef']['domain']}.crt" do
  content node['cf_ha_chef']['certs']['domain_crt']
  owner 'root'
  group 'root'
  mode 00644
end

template "/var/opt/opscode/nginx/ca/chef.#{node['cf_ha_chef']['domain']}.key" do
  source 'chef.key.erb'
  owner 'root'
  group 'root'
  variables({
       key: citadel['certs/key']
  })
  mode 00644
end
