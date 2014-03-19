#
# Cookbook Name:: myproject
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'build-essential'
include_recipe 'chef_handler'
include_recipe 'git'
include_recipe 'dmg'
include_recipe 'python'


user "urban4m" do
  shell "/bin/bash"
  home "/home/urban4m"
  comment "Urban4M"
  supports :manage_home=>true
  action :create
end


##create virtualenv
python_virtualenv "/home/urban4m/urban4menv" do
  interpreter "python2.7"
  owner "urban4m"
  group "urban4m"
  action :create
end


#create source directory to download application repo.
directory "/usr/local/mysource" do
  owner "urban4m"
  group "urban4m"
  mode 0755
  action :create
end


#clone application to directory
git "/usr/local/mysource/django" do
  repository "https://github.com/django/django"
  revision "master"
  action :sync
end

#install application.
python_pip "/usr/local/mysource/django" do
  virtualenv "/home/urban4m/urban4menv"
  options '-e'
end

