#
# Cookbook Name:: cf_ha_chef
# Recipe:: primary_post
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

# Must be run before attempting to install reporting
execute "chef-server-ctl reconfigure"

# Start Again and Reconfigure after changes
execute "chef-server-ctl restart" do
  action :run
  retries 3
  retry_delay 30
  notifies :run, 'execute[sleep]', :immediately
end

# Make sure we have installed the push jobs and reporting add-ons
include_recipe 'cf_ha_chef::reporting'
include_recipe 'cf_ha_chef::push_jobs'

# Start Again and Reconfigure after changes
execute "chef-server-ctl restart" do
  action :run
  retries 3
  retry_delay 30
  notifies :run, 'execute[sleep]', :immediately
end

# Configure for reporting and push jobs
execute 'opscode-reporting-ctl reconfigure'
execute 'opscode-push-jobs-server-ctl reconfigure'

# Start Again and Reconfigure after changes
execute "chef-server-ctl restart" do
  action :run
  retries 3
  retry_delay 30
  notifies :run, 'execute[sleep]', :immediately
end

execute "chef-server-ctl reconfigure"

execute "sleep" do
  command "sleep 80"
  action :nothing
end

# At this point we should have a working primary backend.  Let's pack up all
# the configs and make them available to the other machines.
execute "analytics-bundle" do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/analytics-bundle.tar.gz /etc/opscode-analytics"
  action :run
end

execute "core-bundle" do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/core_bundle.tar.gz /etc/opscode"
  action :run
end

execute "reporting-bundle" do
  command "tar -czvf #{Chef::Config[:file_cache_path]}/reporting_bundle.tar.gz /etc/opscode-reporting"
  action :run
end

# Now we have to have a way to serve it to the other machines.
# We'l spin up a lightweight Ruby webserver for this purpose.
template '/etc/init.d/ruby_webserver' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
  source 'ruby_webserver.erb'
end

# Start up the web server on port 31337
service 'ruby_webserver' do
  action :start
  supports :status => true
end
