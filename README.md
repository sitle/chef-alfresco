# Alfresco chef cookbook

[![Build
Status](https://travis-ci.org/sitle/chef-alfresco.svg?branch=develop)](https://travis-ci.org/sitle/chef-alfresco)

This cookbook install and configure [Alfresco](http://www.alfresco.com/). It is heavily based on the excellent work of [loftuxab](https://github.com/loftuxab/alfresco-ubuntu-install).


## Supported Platforms

* Ubuntu 14.04
* Debian 7

## Attributes

There is lot of attributes you can configure, please feel free to look into ```attributes/default.rb```.

The most important one are :

* default['alfresco']['version'] : set the alfresco version (default : 5.0.c)
* default['alfresco']['database_type'] : set the database type (default : mysql)
* default['alfresco']['domain_name'] : set the default reverse domain name (default : alfresco.dev)

If you have an internal HTTP repository with your own alfresco, share or solr war :

* default['alfresco']['alfresco_link'] = 'http://YOUR_REPOSITORY/alfresco.war'
* default['alfresco']['share_link'] = 'http://YOUR_REPOSITORY/share.war'
* default['alfresco']['solr_link'] = 'http://YOUR_REPOSITORY/solr.war'

## Usage

Include `alfresco` in your node's `run_list`:

```
{
  "run_list": [
    "recipe[alfresco::database]",
    "recipe[alfresco::alfresco]",
    "recipe[alfresco::share]",
    "recipe[alfresco::solr]",
    "recipe[alfresco::reverse]"
  ]
}
```

## Evaluation/Development

### Prerequisite

* chefdk - chef developers only ([https://downloads.chef.io/chef-dk/](https://downloads.chef.io/chef-dk/))
* vagrant ([https://www.vagrantup.com/](https://www.vagrantup.com/))
* vagrant plugins :
  * vagrant-cachier : ```vagrant plugin install vagrant-cachier```
  * vagrant-omnibus : ```vagrant plugin install vagrant-omnibus```
  * vagrant-hostmanager : ```vagrant plugin install vagrant-hostmanager```
  * vagrant-berkshelf : ```vagrant plugin install vagrant-berkshelf```
* virtualbox ([https://www.virtualbox.org/](https://www.virtualbox.org/))
* At least 2Go of RAM for the VM (This is java after all :D)

### Provisionning

#### Evaluation

After installing all the prerequisite, change the BOX_URL and BOX_NAME attributes in ```Vagrantfile``` then :

```
git clone https://github.com/sitle/chef-alfresco.git
cd chef-alfresco
vagrant up
```

Note : you need to wait a few minutes after provisionning is done to let tomcat start Alfresco (2Min). You can, then, access to it (http://alfresco.dev - admin/admin).

#### Development

After installing all the prerequisite, change the box_url attribute in ```.kitchen.yml``` then :

```
git clone https://github.com/sitle/chef-alfresco.git
cd chef-alfresco
kitchen converge default
```

Note : you need to wait a few minutes after provisionning is done to let tomcat start Alfresco (2Min). You can, then, access to it (http://alfresco.dev - admin/admin).

### Known issue

* I don't know why but you need to delete the solr4.zip in your vagrant-cachier (USER_HOME/vagrant.d/cache/SYSTEME/chef/solr4.zip) the second time you spin up your VM.
* solr log still have access denied.

### Todo

* Alfresco plugin LWRP
* Clustering (with search)
* HTTPS
* All critical attributes in data bag
* RedHat like install

## License and Authors

```
Copyright 2015 Léonard TAVAE

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

Authors :

* Léonard TAVAE (<leonard.tavae@informatique.gov.pf>)
