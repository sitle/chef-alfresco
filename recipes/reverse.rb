#
# Cookbook Name:: alfresco
# Recipe:: reverse
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

include_recipe 'alfresco::default'
include_recipe 'apache2::default'

case node['platform']
when 'debian'
  %w(libapache2-mod-proxy-html).each do |package|
    package package do
      action :install
    end
  end
when 'ubuntu'
  include_recipe 'apache2::mod_authz_core'
  include_recipe 'apache2::mod_xml2enc'
  include_recipe 'apache2::mod_proxy_html'
end

include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_ajp'

if node['alfresco']['reverse'] == true
  node.default['alfresco']['alfresco_port'] = 80
  node.default['alfresco']['share_port'] = 80
end

web_app 'alfresco-reverse-proxy' do
  template 'alfresco-reverse-proxy.erb'
  server_name node['alfresco']['domain_name']
  cookbook 'alfresco'
end
