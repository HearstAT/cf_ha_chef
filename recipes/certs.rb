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

directory "#{node['cf_ha_chef']['s3']['dir']}/certs" do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

include_recipe 'letsencrypt'

execute 'restart-nginx' do
  command 'chef-server-ctl restart nginx'
  action :nothing
end

execute 'sleep' do
  command 'sleep 30'
  action :nothing
end

# Generate selfsigned certificate so nginx can start
letsencrypt_selfsigned "chef.#{node['cf_ha_chef']['prime_domain']}" do
  crt "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['prime_domain']}.crt"
  key "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['prime_domain']}.key"
  not_if do ::File.exists?("#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['prime_domain']}.crt") end
end

# Generate real cert
letsencrypt_certificate "chef.#{node['cf_ha_chef']['prime_domain']}" do
  fullchain "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['prime_domain']}.crt"
  key "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['prime_domain']}.key"
  alt_names ["analytics.#{node['cf_ha_chef']['prime_domain']}",
             "#{node['cf_ha_chef']['analytics']['stage_subdomain']}.#{node['cf_ha_chef']['prime_domain']}",
             "#{node['cf_ha_chef']['stage_subdomain']}.#{node['cf_ha_chef']['prime_domain']}"]
  method 'http'
  wwwroot '/var/opt/opscode/nginx/html'
  only_if { node['fqdn'] == node['cf_ha_chef']['frontends']['fe01']['fqdn'] }
  notifies :run, 'execute[sleep]', :immediately
  notifies :run, 'execute[restart-nginx]', :immediately
end

letsencrypt_selfsigned "chef.#{node['cf_ha_chef']['secondary_domain']}" do
  crt "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['secondary_domain']}.crt"
  key "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['secondary_domain']}.key"
  not_if do ::File.exists?("#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['secondary_domain']}.crt") end
  only_if { node['cf_ha_chef']['secondary_domain'] }
end

letsencrypt_certificate "chef.#{node['cf_ha_chef']['secondary_domain']}" do
  fullchain "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['secondary_domain']}.crt"
  key "#{node['cf_ha_chef']['s3']['dir']}/certs/chef.#{node['cf_ha_chef']['secondary_domain']}.key"
  alt_names ["analytics.#{node['cf_ha_chef']['secondary_domain']}",
             "#{node['cf_ha_chef']['analytics']['stage_subdomain']}.#{node['cf_ha_chef']['secondary_domain']}",
             "#{node['cf_ha_chef']['stage_subdomain']}.#{node['cf_ha_chef']['secondary_domain']}"]
  method 'http'
  wwwroot '/var/opt/opscode/nginx/html'
  only_if { node['fqdn'] == node['cf_ha_chef']['frontends']['fe01']['fqdn'] }
  only_if { node['cf_ha_chef']['secondary_domain'] }
  notifies :run, 'execute[sleep]', :immediately
  notifies :run, 'execute[restart-nginx]', :immediately
end
