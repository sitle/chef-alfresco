#
# Cookbook Name:: alfresco
# Recipe:: _tomcat
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

# Java installation
#
node.set['java']['install_flavor'] = 'openjdk'
node.set['java']['jdk_version'] = '7'
node.set['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java::default'

# Tomcat installation
#
node.set['tomcat']['base_version'] = '7'
node.set['tomcat']['user'] = 'tomcat7'
node.set['tomcat']['group'] = 'tomcat7'
node.set['tomcat']['home'] = '/usr/share/tomcat7'
node.set['tomcat']['config_dir'] = '/etc/tomcat7'
node.set['tomcat']['base'] = '/var/lib/tomcat7'
node.set['tomcat']['config_dir'] = '/etc/tomcat7'
node.set['tomcat']['log_dir'] = '/var/log/tomcat7'
node.set['tomcat']['tmp_dir'] = '/tmp/tomcat7-tmp'
node.set['tomcat']['work_dir'] = '/var/cache/tomcat7'
node.set['tomcat']['webapp_dir'] = '/var/lib/tomcat7/webapps'
node.set['tomcat']['keytool'] = '/usr/bin/keytool'
node.set['tomcat']['java_options'] = '-XX:MaxPermSize=512m -Xms1G -Xmx1G -XX:-DisableExplicitGC -Djava.awt.headless=true -Dalfresco.home=/opt/alfresco -Dcom.sun.management.jmxremote -Dsun.security.ssl.allowUnsafeRenegotiation=true'

include_recipe 'tomcat::default'

service 'tomcat7' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

directory node['tomcat']['base'] + '/shared/classes/alfresco/extension' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

directory node['tomcat']['base'] + '/shared/classes/alfresco/web-extension' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

template '/etc/tomcat7/catalina.properties' do
  source 'catalina.properties.erb'
  owner 'root'
  group 'tomcat7'
  mode '0644'
end

template node['tomcat']['config_dir'] + '/server.xml' do
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template node['tomcat']['config_dir'] + '/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
  owner 'root'
  group 'tomcat7'
  mode '0640'
end

case node['alfresco']['database_type']
when 'mysql'
  # Download Mysql JDBC connector for JAVA
  #
  remote_file node['alfresco']['home'] + '/mysql_jdbc.tar.gz' do
    owner node['alfresco']['apps_user']
    group node['alfresco']['apps_group']
    mode '0644'
    source node['alfresco']['mysql_jdbc_link']
    not_if { ::File.exist?('/usr/share/tomcat7/lib/mysql-connector-java-5.1.34-bin.jar') }
  end

  # Extracting the connector
  #
  bash 'Extract mysql-connector' do
    user 'root'
    cwd node['alfresco']['home']
    code <<-EOH
  tar -xvzf mysql_jdbc.tar.gz mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar
  mv #{node['alfresco']['home']}/mysql-connector-java-5.1.34/* /usr/share/tomcat7/lib/
  rm -fr #{node['alfresco']['home']}/mysql*
    EOH
    not_if { ::File.exist?('/usr/share/tomcat7/lib/mysql-connector-java-5.1.34-bin.jar') }
  end
when 'postgresql'
  # Download Postgresql JDBC connector for JAVA
  #
  remote_file node.set['tomcat']['home'] + '/lib/postgresql-jdbc.jar' do
    owner node['alfresco']['apps_user']
    group node['alfresco']['apps_group']
    mode '0644'
    source node['alfresco']['postgresql_jdbc_link']
    not_if { ::File.exist?(node.set['tomcat']['home'] + '/lib/postgresql-jdbc.jar') }
  end
end

# Link to tomcat from alfresco home
#
link node['alfresco']['home'] + '/tomcat' do
  to node['tomcat']['base']
end
