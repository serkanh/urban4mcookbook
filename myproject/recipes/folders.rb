include_recipe 'git'

#create source directory to download application repo.
directory "/usr/local/mysource" do
  owner "urban4m"
  group "urban4m"
  mode 0755
  action :create
end

#clone application to directory
git "/usr/local/mysource/urbanpy" do
  repository "ssh://git@54.84.1.39/git/urban/urbanpy"
  revision "master"
  action :sync
end

