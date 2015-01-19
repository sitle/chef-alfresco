
# General settings
#
default['alfresco']['version'] = '5.0.c'
default['alfresco']['java_version'] = '7'
default['alfresco']['java_type'] = 'openjdk'
default['alfresco']['mysql_connector_version'] = '5.1.34'

# Database settings
#
default['alfresco']['database_type'] = 'mysql'
default['alfresco']['database'] = 'alfresco'
default['alfresco']['database_user'] = 'alfresco'
default['alfresco']['database_password'] = 'password'
default['alfresco']['database_root_password'] = 'password'
default['alfresco']['database_server'] = 'localhost'
default['alfresco']['database_port'] = 'localhost'
default['alfresco']['apps_server'] = 'localhost'

# Alfresco application settings
#
default['alfresco']['alfresco_link'] = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco/#{node['alfresco']['version']}/alfresco-#{node['alfresco']['version']}.war"
default['alfresco']['share_link'] = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/share/#{node['alfresco']['version']}/share-#{node['alfresco']['version']}.war"
default['alfresco']['solr_link'] = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/#{node['alfresco']['version']}/alfresco-solr4-#{node['alfresco']['version']}-ssl.war"
default['alfresco']['solr_config_link'] = "https://artifacts.alfresco.com/nexus/service/local/repo_groups/public/content/org/alfresco/alfresco-solr4/#{node['alfresco']['version']}/alfresco-solr4-#{node['alfresco']['version']}-config-ssl.zip"
default['alfresco']['swf_link'] = 'http://www.swftools.org/swftools-2013-04-09-1007.tar.gz'
default['alfresco']['mysql_jdbc_link'] = "http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-#{node['alfresco']['mysql_connector_version']}.tar.gz"

default['alfresco']['postgresql_jdbc_link'] = 'http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar'

default['alfresco']['keystore_link'] = 'http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore'

default['alfresco']['alfresco_port'] = 8080
default['alfresco']['alfresco_protocol'] = 'http'
default['alfresco']['share_port'] = 8080
default['alfresco']['share_protocol'] = 'http'
default['alfresco']['home'] = '/opt/alfresco'
default['alfresco']['data'] = node['alfresco']['home'] + '/alf_data'
default['alfresco']['apps_user'] = 'tomcat7'
default['alfresco']['apps_group'] = 'tomcat7'

# Alfresco reverse proxy settings
#
default['alfresco']['reverse'] = true
default['alfresco']['domain_name'] = 'alfresco.dev'
