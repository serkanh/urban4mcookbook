include_recipe 'git'

#create source directory to download application repo.
directory "/usr/local/mysource" do
  owner "urban4m"
  group "urban4m"
  mode 0755
  action :create
end

#clone application to directory
git "/usr/local/mysource/django" do
  repository "https://github.com/django/django"
  revision "master"
  action :sync
end

