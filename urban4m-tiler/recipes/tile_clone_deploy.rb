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
  sudo service smartmap_tiler restart
  EOH
end






