#
# Cookbook Name:: alfresco
# Recipe:: _depends
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

# For Debian distribution, we need to enable the contrib repository
#
if node['platform'] == 'debian'
  include_recipe 'apt::default'
  apt_repository 'contrib' do
    uri 'http://repository.linux.pf/debian'
    distribution node['lsb']['codename']
    components ['contrib']
  end
end

# Libreoffice installation
#
%w(libreoffice ttf-mscorefonts-installer fonts-droid).each do |package|
  package package do
    action :install
  end
end

# Swftool installation
#
%w(make build-essential ccache g++ libgif-dev libjpeg62-dev libfreetype6-dev libpng12-dev libt1-dev libfreetype6-dev libjpeg-dev libgif-dev).each do |package|
  package package do
    action :install
  end
end

ark 'swftool' do
  url node['alfresco']['swf_link']
  action [:configure]
end

bash 'install_swftool' do
  user 'root'
  cwd '/usr/local/swftool-1'
  code <<-EOH
  ./configure
  make
  make install
  EOH
  not_if { ::File.exist?('/usr/local/bin/pdf2swf') }
end

# Imagemagick installation
#
package 'imagemagick' do
  action :install
end

# Alfresco Directory structure creation
#
directory node['alfresco']['home'] + '/addons/alfresco' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

directory node['alfresco']['home'] + '/addons/share' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
  recursive true
end

directory node['alfresco']['data'] + '/contentstore' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

directory node['alfresco']['home'] + '/scripts/' do
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0755'
  action :create
end

# limitconvert.sh is used to limit ressources for ImageMagick converter
#
cookbook_file node['alfresco']['home'] + '/scripts/limitconvert.sh' do
  source 'limitconvert.sh'
  owner node['alfresco']['apps_user']
  group node['alfresco']['apps_group']
  mode '0754'
end
