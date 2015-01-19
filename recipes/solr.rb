#
# Cookbook Name:: alfresco
# Recipe:: solr
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
include_recipe 'alfresco::_tomcat'

directory node['alfresco']['home'] + '/solr4' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

ark 'solr' do
  url node['alfresco']['solr_link']
  path node['tomcat']['base'] + '/webapps/'
  strip_components 0
  action :put
end

template node['tomcat']['base'] + '/webapps/solr/WEB-INF/classes/log4j.properties' do
  source 'solr-log4j.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
  notifies :restart, 'service[tomcat7]'
end

ark 'solr4' do
  url node['alfresco']['solr_config_link']
  path node['alfresco']['home']
  strip_components 0
  action :put
end

execute 'Change solr4 directory owner' do
  command 'chown -R ' + node['alfresco']['apps_user'] + ':' + node['alfresco']['apps_group'] + ' ' + node['alfresco']['home'] + '/solr4'
  action :run
end

template node['tomcat']['config_dir'] + '/Catalina/localhost/solr.xml' do
  source 'solr4.xml.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
end

template node['alfresco']['home'] + '/solr4/workspace-SpacesStore/conf/solrcore.properties' do
  source 'workspace-solrcore.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
end

template node['alfresco']['home'] + '/solr4/archive-SpacesStore/conf/solrcore.properties' do
  source 'archive-solrcore.properties.erb'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0644'
end
