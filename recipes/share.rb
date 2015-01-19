#
# Cookbook Name:: alfresco
# Recipe:: share
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

remote_file node['alfresco']['home'] + '/addons/war/share.war' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  source node['alfresco']['share_link']
  not_if { ::File.exist?(node['alfresco']['home'] + '/addons/war/share.war') }
end

ark 'share' do
  url node['alfresco']['share_link']
  path node['tomcat']['base'] + '/webapps/'
  strip_components 0
  action :put
end

template node['tomcat']['base'] + '/shared/classes/alfresco/web-extension/share-config-custom.xml' do
  source 'share-config-custom.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[tomcat7]'
end

template node['tomcat']['base'] + '/webapps/share/WEB-INF/classes/log4j.properties' do
  source 'share-log4j.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  notifies :restart, 'service[tomcat7]'
end
