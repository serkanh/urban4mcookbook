include_recipe 'git'
include_recipe 'python'


#Pull model from the deployment server
git "/home/urban4m/deploy/ap/model" do
  user "urban4m"
  repository "ssh://git@10.0.0.63/git/ap/model.git"
  revision "master"
  action :sync
end


#Pull urbanpy from the deployment server
git "/home/urban4m/deploy/urban/urbanpy" do
  user "urban4m"
  repository "ssh://git@10.0.0.63/git/urban/urbanpy.git"
  revision "master"
  action :sync
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
  sudo service smartmap_worker restart
  sudo service smartmap_web restart
  EOH
end






