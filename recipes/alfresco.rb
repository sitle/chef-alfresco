#
# Cookbook Name:: alfresco
# Recipe:: alfresco
#
# Copyright (C) 2015 Leonard TAVAE
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'alfresco::_common'
include_recipe 'alfresco::_depends'
include_recipe 'alfresco::_tomcat'

remote_file node['alfresco']['home'] + '/addons/war/alfresco.war' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  source node['alfresco']['alfresco_link']
  not_if { ::File.exist?(node['alfresco']['home'] + '/addons/war/alfresco.war') }
end

ark 'alfresco' do
  url node['alfresco']['alfresco_link']
  path node['tomcat']['base'] + '/webapps/'
  strip_components 0
  action :put
end

template node['tomcat']['base'] + '/shared/classes/alfresco-global.properties' do
  source 'alfresco-global.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  notifies :restart, 'service[tomcat7]'
end

template node['tomcat']['base'] + '/webapps/alfresco/WEB-INF/classes/log4j.properties' do
  source 'alfresco-log4j.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  notifies :restart, 'service[tomcat7]'
end
