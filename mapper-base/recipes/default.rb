#
# Cookbook Name:: Tiler Base Server Setup
# Recipe:: default
#
# Copyright 2014, Urban4m
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



#create urban4m user
#user "urban4m" do
#  supports :manage_home=>true
#  comment "Urban4m User"
#  home "/home/urban4m"
#  shell "/bin/bash"
#end



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

#Installs Postgresql
bash "install_postgres" do
  code <<-EOH
  curl -L 'http://anonscm.debian.org/loggerhead/pkg-postgresql/postgresql-common/trunk/download/head:/apt.postgresql.org.s-20130224224205-px3qyst90b3xp8zj-1/apt.postgresql.org.sh' |  sudo bash -
  sudo apt-get install -y postgresql-server-dev-9.3
  EOH
end

#Installs Ubuntugis
bash "install_ubuntugis" do
  code <<-EOH
  sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && sudo apt-get -y update && sudo apt-get install -y gdal-bin libgdal-dev
  EOH
end


#Installs redis server.
bash "install_common" do
  code <<-EOH
  sudo apt-get install -y libxslt1-dev proj python-software-properties python python-dev postgresql-client-9.3 g++ make graphviz-dev unzip openjdk-7-jre-headless
  EOH
end

#
# Installs redis server.
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

#
# Installs ImageMagick - Optional package to
# build docs for postgis.Added for testing purposes.
#
bash "install_imagemagick" do
  code <<-EOH
  sudo apt-get install -y imagemagick
  EOH
end


#
# Get Postgis
#
bash "get_postgis" do
  cwd "/home/urban4m/"
  code <<-EOH
  curl -OLs "http://download.osgeo.org/postgis/source/postgis-2.1.1.tar.gz"
  EOH
end

#
# Extract Postgis
#
bash "download_extract_postgis" do
  cwd "/home/urban4m/"
  code <<-EOH
  tar zxf postgis-2.1.1.tar.gz
  EOH
end

#
# Install Postgis
#
bash "install_postgis" do
  cwd "/home/urban4m/postgis-2.1.1"
  code <<-EOH
  sudo ./configure && make && make install
  EOH
end


#
# psycopg2 -> requires libpq-dev
#
bash "python_libs_pre_reqs" do
  code <<-EOH
  sudo apt-get install -y libpq-dev
  EOH
end

#Install python libraries
bash 'install_python_libs' do
  user "urban4m"
  code <<-EOH
  source ./home/urban4m/venv-tiler/bin/activate && pip install uwsgi pillow simplejson werkzeug psycopg2 redis python-memcached blit sympy
  source ./home/urban4m/venv-tiler/bin/activate && pip install --allow-all-external --allow-unverified pyproj pyproj
  EOH
end



bash 'install_gdal' do
  code <<-EOH
  export CPLUS_INCLUDE_PATH="/usr/include/gdal"
  export C_INLUDE_PATH="/usr/include/gdal"
  sudo -E pip install gdal
  EOH
end


bash 'install_mapnik' do
  code <<-EOH
  source ./home/urban4m/venv-tiler/bin/activate && sudo pip install --allow-all-external --allow-unverified ModestMaps ModestMaps
  sudo add-apt-repository -y ppa:mapnik/v2.2.0 && sudo apt-get -y update
  sudo apt-get install -y libmapnik libmapnik-dev mapnik-utils python-mapnik
  EOH
end


