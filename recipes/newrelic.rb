#
# Cookbook Name:: cf_ha_chef
# Recipe:: new_relic.rb
#
# Copyright (C) 2016 Hearst Business Media
#

include_recipe 'python::pip'

newrelic_license_key = citadel['newrelic/license_key']

newrelic_server_monitor 'Install' do
  license newrelic_license_key
end

newrelic_meetme_plugin 'default' do
  license newrelic_license_key
  additional_requirements node['cf_ha_chef']['newrelic']['plugins']
end

newrelic_agent_ruby 'Install' do
  license newrelic_license_key
  app_name 'Chef_Server_Stack'
end
