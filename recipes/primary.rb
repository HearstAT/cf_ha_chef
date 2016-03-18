#
# Cookbook Name:: cf_ha_chef
# Recipe:: primary
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

include_recipe 'cf_ha_chef::ebs_volume'
include_recipe 'cf_ha_chef::disable_iptables'
include_recipe 'cf_ha_chef::certs'
include_recipe 'cf_ha_chef::newrelic'
include_recipe 'cf_ha_chef::sumologic'

template '/etc/hosts' do
  action :create
  source 'primary_hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

# Make sure /etc/opscode exists
directory '/etc/opscode' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

# Render the chef-server.rb config file
template '/etc/opscode/chef-server.rb' do
  action :create
  source 'chef_server.erb'
  owner 'root'
  group 'root'
  mode '0644'
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
  content 'master'
  owner 'root'
  group 'root'
  mode '0644'
end

file '/var/opt/opscode/keepalived/requested_cluster_status' do
  action :create
  content 'master'
  owner 'root'
  group 'root'
  mode '0644'
end

# Must be run before attempting to install reporting
execute 'chef-server-ctl reconfigure'

# Start Again and Reconfigure after changes
execute 'chef-server-ctl restart' do
  action :run
  retries 3
  retry_delay 60
end

# Make sure we have installed the push jobs and reporting add-ons
include_recipe 'cf_ha_chef::reporting'
include_recipe 'cf_ha_chef::push_jobs'

# Start Again and run backup restore if enabled
execute 'chef-server-ctl restart' do
  action :run
  retries 3
  retry_delay 60
end

execute 's3-backup-get' do
  command "aws s3 cp s3://#{node['cf_ha_chef']['s3']['backup_bucket']}/backup.tar #{Chef::Config[:file_cache_path]}/backup.tar"
  action :run
  only_if { node['cf_ha_chef']['backup_restore'] }
end

execute 'backup-extract' do
  command "tar -xzf #{Chef::Config[:file_cache_path]}/backup.tar --strip-components=1"
  action :run
  cwd "#{Chef::Config[:file_cache_path]}"
  only_if { node['cf_ha_chef']['backup_restore'] }
end

execute 'knife-backup-restore' do
  command "/opt/opscode/embedded/bin/knife ec restore #{Chef::Config[:file_cache_path]}/backup -s https://#{node['cf_ha_chef']['api_fqdn']} --with-user-sql --skip-useracl --concurrency 1"
  action :run
  only_if { node['cf_ha_chef']['backup_restore'] }
end

# Configure for reporting and push jobs again
execute 'opscode-reporting-ctl reconfigure'
execute 'opscode-push-jobs-server-ctl reconfigure'

# Start Again and Reconfigure after changes
execute 'chef-server-ctl restart' do
  action :run
  retries 3
  retry_delay 60
end

execute 'chef-server-ctl reconfigure'

# At this point we should have a working primary backend.  Let's pack up all
# the configs and make them available to the other machines.
execute 'analytics-bundle' do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/analytics_bundle.tar.gz /etc/opscode-analytics"
  action :run
end

execute 'core-bundle' do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/core_bundle.tar.gz /etc/opscode"
  action :run
end

execute 'reporting-bundle' do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/reporting_bundle.tar.gz /etc/opscode-reporting"
  action :run
end

execute 's3-analytics-bundle' do
  command "aws s3 cp #{Chef::Config[:file_cache_path]}/analytics_bundle.tar.gz s3:/#{node['cf_ha_chef']['s3']['backup_bucket']}/analytics_bundle.tar.gz"
  action :run
end

execute 's3-core-bundle' do
  command "aws s3 cp #{Chef::Config[:file_cache_path]}/core_bundle.tar.gz s3:/#{node['cf_ha_chef']['s3']['backup_bucket']}/core_bundle.tar.gz"
  action :run
end

execute 's3-reporting-bundle' do
  command "aws s3 cp #{Chef::Config[:file_cache_path]}/reporting_bundle.tar.gz s3:/#{node['cf_ha_chef']['s3']['backup_bucket']}/reporting_bundle.tar.gz"
  action :run
end
