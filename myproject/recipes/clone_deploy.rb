include_recipe 'git'
include_recipe 'python'


#create source directory to download application repo.
directory "/usr/local/urbanpy" do
  owner "urban4m"
  group "urban4m"
  mode 0755
  action :create
end


#clone application to directory
git "/usr/local/urbanpy" do
  repository "ssh://git@git.urban4m.com:7999/urban/urbanpy.git"
  revision "master"
  action :sync
end




python_virtualenv "/home/urban4m/urban4menv" do
  interpreter "python2.7"
  owner "urban4m"
  group "urban4m"
  action :create
end


install application.
python_pip "/usr/local/urbanpy" do
  virtualenv "/home/urban4m/urban4menv"
  options '-e'
end
