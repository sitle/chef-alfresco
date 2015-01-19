#
# Cookbook Name:: alfresco
# Recipe:: _common
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

# Unzip install
#
package 'unzip' do
  action :install
end

# Create Alfresco user and group
#
group node['alfresco']['apps_group'] do
  system true
  gid 114
  action :create
end

user node['alfresco']['apps_user'] do
  system true
  uid 106
  gid 114
  home '/usr/share/tomcat7'
  shell '/bin/false'
  action :create
end

# Alfresco home directory
#
directory node['alfresco']['home'] do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

# Alfresco addons directory
#
directory node['alfresco']['home'] + '/addons' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

# Alfresco data directory
#
directory node['alfresco']['data'] do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

# Alfresco war directory
#
directory node['alfresco']['home'] + '/addons/war' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

# Alfresco keystore directory
#
directory node['alfresco']['data'] + '/keystore' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

# Alfresco logs directory
#
directory node['alfresco']['home'] + '/logs' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

# Download Alfresco keystore
#
%w(browser.p12 generate_keystores.sh keystore keystore-passwords.properties ssl-keystore-passwords.properties ssl-truststore-passwords.properties ssl.keystore ssl.truststore).each do |key|
  remote_file "Download #{key} file" do
    path node['alfresco']['data'] + '/keystore/' + key
    owner node['alfresco']['apps_user']
    group node['alfresco']['apps_group']
    mode '0644'
    source node['alfresco']['keystore_link'] + '/' + key
    not_if { ::File.exist?(node['alfresco']['data'] + '/keystore/' + key) }
  end
end
