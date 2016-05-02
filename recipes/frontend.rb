#
# Cookbook Name:: cf_ha_chef
# Recipe:: frontend
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

package 'chef-manage'
package 'chef-server-core'

template '/etc/hosts' do
  action :create
  source 'frontend_hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

include_recipe 'cf_ha_chef::disable_iptables'
include_recipe 'cf_ha_chef::manage'
include_recipe 'cf_ha_chef::mail'
include_recipe 'cf_ha_chef::certs'
include_recipe 'cf_ha_chef::server_install'
include_recipe 'cf_ha_chef::stage'
include_recipe 'cf_ha_chef::newrelic'
include_recipe 'cf_ha_chef::sumologic'
