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


#Runs apt-get to update repos
execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end


package "update-notifier-common" do
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
   File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
   File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

#
# Check env variable to determine whether
# this is local vagrant env or aws server
#

package "curl"

bash "install_pip"  do
   user "urban4m"
   code <<-EOH
   sudo apt-get install curl
   curl -L 'https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python'
   EOH
end


#
# Install Redis Server
#
bash "install-redis" do
  user "urban4m"
   code <<-EOH
   sudo add-apt-repository -y ppa:rkwy/redis
   sudo apt-get -y install redis
   EOH
end








