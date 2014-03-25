#
# Cookbook Name:: Tiler Base Server Setup
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#
# - check whether the repos are update
# - install curl and pip
# - install redis server
# - install pythons pa
#
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

#Installs redis server.No sudo needed.

bash "install_common" do
  code <<-EOH
  sudo apt-get install -y libxslt1-dev proj python-software-properties python g++ make graphviz-dev python-dev unzip openjdk-7-jre-headless
  EOH
end

#
# Installs redis server.No SUDO needed
# beacause of the previous line of code
#
bash "install_redis" do
  code <<-EOH
  add-apt-repository -y ppa:rwky/redis && sudo apt-get -y update && sudo apt-get install redis-server
  EOH
end


#
# Create .gitignore file in home folder
#
file "/home/urban4m/.gitignore" do
  owner "urban4m"
  action :create
end

bash "git_ignore_edit" do
  user "urban4m"
  code <<-EOH
   echo -e ".bash_history
  .bash_logout
  .distlib/
  .viminfo
  .cache
  .ssh/
  .sudo_ad_admin_successful
  9.3/
  postgis-2.1.1/
  *.jar
  *.zip
  *.gz
  *.tbz2
  *.tar
  *.bz2
  ">/home/urban4m/.gitignore
  EOH
end





python_virtualenv "/home/urban4m/venv-tiler" do
  interpreter "python2.7"
  owner "urban4m"
  group "urban4m"
  action :create
end

package "curl"

#bash "install_pip"  do
#   user "urban4m"
#   code <<-EOH
#   sudo apt-get install curl
#   curl -L 'https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python'
#   EOH
#end



#pip-packages = ['uwsgi','pillow','simplejson']
#for packg in pip-packages
#    python_pip #{packg} do
#      virtualenv "/home/urban4m/venv-tiler"
#      action :install
#    end

#python_pip 'pillow' do
#  virtualenv "/home/urban4m/venv-tiler"
#  action :install
#end

#install application.
#python_pip "simplejson" do
#  user "urban4m"
#  virtualenv "/home/urban4m/venv-tiler"
#  options '-e'
#end


#
# psycopg2 -> requires libpq-dev
#
bash "python_pre_reqs" do
  code <<-EOH
  sudo apt-get install -y libpq-dev
  EOH
end


bash 'install_pip'do
  user "urban4m"
  code <<-EOH
  source ./home/urban4m/venv-tiler/bin/activate && pip install uwsgi pillow simplejson werkzeug psycopg2 redis python-memcached blit sympy
  EOH
end





