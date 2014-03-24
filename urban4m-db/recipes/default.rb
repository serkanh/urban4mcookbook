#
# Cookbook Name:: urban4m-db
# Recipe:: default
#
# Copyright 2014, Urban4m
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'
include_recipe 'python'




bash "run_pull"  do
  user "urban4m"
  code <<-EOH
  bash /home/urban4m/deploy/update.sh
  EOH
end

#install application.
python_pip "/home/urban4m/deploy/urban/urbanpy" do
  virtualenv "/home/urban4m/venv-tiler"
  options '-e'
end

#restart smartmap
bash "smartmap_restart"  do
  user "ubuntu"
  code <<-EOH
  sudo service smartmap_web restart
  sudo service smartmap_worker restart
  EOH
end















