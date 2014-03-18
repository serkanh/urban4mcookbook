#
# Cookbook Name:: myproject
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#execute "apt-get-update-periodic" do
#  command "apt-get update"
#  ignore_failure true
#  only_if do
#    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
#    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
#  end
#end

#include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'chef_handler'
include_recipe 'git'
include_recipe 'dmg'
include_recipe 'python'
#include_recipe 'yum'
#include_recipe 'yum-epel'
#include_recipe 'vim'


python_virtualenv "/home/urban4m/urban4menv" do
  interpreter "python2.7"
  owner "urban4m"
  group "urban4m"
  action :create
end



directory "/usr/local/mysource" do
  owner "urban4m"
  group "urban4m"
  mode 0755
  action :create
end



git "/usr/local/mysource/django" do
  repository "https://github.com/django/django"
  revision "master"
  action :sync
end


python_pip "/usr/local/mysource/django" do
  virtualenv "/home/urban4m/urban4menv"
  options '-e'
end

