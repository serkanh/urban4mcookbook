include_recipe 'git'
include_recipe 'python'

#Pull map-styles from the deployment server
git "/home/urban4m/deploy/ap/map-styles" do
  user "urban4m"
  repository "ssh://git@10.0.0.63/git/ap/map-styles.git"
  revision "master"
  action :sync
end





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
  sudo service smartmap_tiler restart
  EOH
end






