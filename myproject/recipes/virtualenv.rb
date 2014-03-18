include_recipe 'build-essential'
include_recipe 'chef_handler'
#include_recipe 'git'
include_recipe 'dmg'
include_recipe 'python'


#create virtualenv
python_virtualenv "/home/urban4m/urban4menv" do
  interpreter "python2.7"
  owner "urban4m"
  group "urban4m"
  action :create
end


#install application.
python_pip "/usr/local/mysource/django" do
  virtualenv "/home/urban4m/urban4menv"
  options '-e'
end

