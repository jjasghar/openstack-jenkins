#
# Cookbook Name:: openstack-jenkins
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


include_recipe 'jenkins::master'

# Test basic plugin installation
jenkins_plugin 'greenballs'

# Test basic plugin installation
jenkins_plugin 'git'

# Install a plugin with many deps
jenkins_plugin 'github-oauth' do
  install_deps true
end

# Install a openstack-cloud
jenkins_plugin 'config-file-provider'

jenkins_plugin 'ssh-slaves'

jenkins_plugin 'openstack-cloud'

# Test basic password credentials creation
jenkins_password_credentials 'jenkins' do
  description 'user for jjb'
  password 'jenkins'
end

# install some packages
%w{git python-pip python-setuptools python-pbr python-jenkinsapi python-dev}.each do |pkg|
  package pkg do
    action [:install]
  end
end

# pull down the jenkin-job-builder
git '/home/ubuntu/jenkins-job-builder' do
  repository 'https://github.com/openstack-infra/jenkins-job-builder'
  revision 'master'
  action :sync
end

# install jenkins-job-builder
bash 'install-jenkins-job-builder' do
  user 'ubuntu'
  cwd '/home/ubuntu/jenkins-job-builder'
  code <<-EOH
    sudo python setup.py install
  EOH
end

# pull down the openstack-chef-jenkins-jjb
git '/home/ubuntu/openstack-chef-jenkins-jjb' do
  repository 'https://github.com/jjasghar/openstack-chef-jenkins-jjb.git'
  revision 'master'
  action :sync
end
