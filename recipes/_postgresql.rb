#
# Cookbook Name:: alfresco
# Recipe:: _postgresql
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

node.set['postgresql']['password']['postgres'] = node['alfresco']['database_root_password']

node.set['postgresql']['pg_hba'] = [
  {
    type: 'local',
    db: 'all',
    user: 'postgres',
    addr: nil,
    method: 'ident'
  },
  {
    type: 'local',
    db: 'all',
    user: 'all',
    addr: nil,
    method: 'ident'
  },
  {
    type: 'host',
    db: 'all',
    user: 'all',
    addr: '127.0.0.1/32',
    method: 'md5'
  },
  {
    type: 'host',
    db: 'all',
    user: 'all',
    addr: '::1/128',
    method: 'md5'
  },
  {
    type: 'host',
    db: node['alfresco']['database'],
    user: node['alfresco']['database_user'],
    addr: '*',
    method: 'ident'
  }
]

# install the database software
include_recipe 'postgresql::server'

# create the database
include_recipe 'database::postgresql'

postgresql_connection_info = {
  host: '127.0.0.1',
  port: 5432,
  username: 'postgres',
  password: node['alfresco']['database_root_password']
}

postgresql_database node['alfresco']['database'] do
  connection postgresql_connection_info
  action :create
end

postgresql_database_user node['alfresco']['database_user'] do
  connection postgresql_connection_info
  password node['alfresco']['database_password']
  action :create
end

postgresql_database_user node['alfresco']['database_user'] do
  connection postgresql_connection_info
  password node['alfresco']['database_password']
  database_name node['alfresco']['database']
  action :grant
end
