#
# Cookbook Name:: cf_ha_chef
# Recipe:: post_install
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

# Run this recipe on every server *but* the primary to configure everything
include_recipe 'cf_ha_chef::reporting'

execute 's3-core-bundle' do
  command "aws s3 cp s3://#{node['cf_ha_chef']['s3']['backup_bucket']}/core_bundle.tar.gz #{Chef::Config[:file_cache_path]}/core_bundle.tar.gz"
  action :run
end

execute 's3-reporting-bundle' do
  command "aws s3 cp s3://#{node['cf_ha_chef']['s3']['backup_bucket']}/reporting_bundle.tar.gz #{Chef::Config[:file_cache_path]}/reporting_bundle.tar.gz"
  action :run
end

# Unpack the server files
execute "tar -zxvf #{Chef::Config[:file_cache_path]}/core_bundle.tar.gz" do
  action :run
  cwd '/'
end

# Unpack the reporting files
execute "tar -zxvf #{Chef::Config[:file_cache_path]}/reporting_bundle.tar.gz" do
  action :run
  cwd '/'
end

# Configure all the things
execute 'chef-server-ctl reconfigure'
execute 'opscode-reporting-ctl reconfigure'
execute 'opscode-manage-ctl reconfigure' do
  action :run
  only_if "dpkg -s chef-manage | grep 'Status: install ok installed'"
end

# Stop the Chef server, but only on the secondary back-end. Some how push
# jobs gets started which causes chef-server-ctl ha-status to error out.
# This step is required to make sure the secondary back-end has nothing
# running that shouldn't be.
execute 'chef-server-ctl stop' do
  action :run
  only_if "hostname -f | grep -q #{node['cf_ha_chef']['backendfailover']['fqdn']}"
end
