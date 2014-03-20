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

#create urban4m user
#user "urban4m" do
#  shell "/bin/bash"
#  home "/home/urban4m"
#  comment "Urban4M"
#  supports :manage_home=>true
#  action :create
#end

#create ssh dir for urban4m
#directory "/home/urban4m/.ssh" do
#  owner "urban4m"
#  group "urban4m"
#  mode 0755
#  action :create
#end








