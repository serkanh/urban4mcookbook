include_recipe 'git'
include_recipe 'python'



#run pull app on the server
bash "run_pull"  do
  user "urban4m"
  code <<-EOH
  bash /home/deploy/update.sh
  EOH
end

#install application.
python_pip "/home/urban4m/deploy/urbanpy" do
  virtualenv "/home/venv-tiler"
  options '-e'
end


#run pull app on the server
bash "smartmap_restart"  do
  user "ubuntu"
  code <<-EOH
  bash service smartmap_tiler restart
  EOH
end






#create source directory to download application repo.
#directory "/usr/local/urbanpy" do
#  owner "urban4m"
#  group "urban4m"
#  mode 0755
#  action :create
#end


#clone application to directory
#git "/usr/local/urbanpy" do
#  repository "http://serkan@git.urban4m.com/scm/urban/urbanpy.git"
#  revision "master"
#  action :sync
#  user "urban4m"
#end




#python_virtualenv "/home/urban4m/urban4menv" do
#  interpreter "python2.7"
#  owner "urban4m"
#  group "urban4m"
#  action :create
#end

