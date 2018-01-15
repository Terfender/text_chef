execute "apt-get update" do
  command "apt-get update"
  user "root"
end



# Install basic packages
%w(git build-essential curl libcurl4-openssl-dev libpcre3 libpcre3-dev).each do |pkg|
  apt_package pkg
end



# Create deploy user
# bash "Create deploy user" do
#   code <<-EOF
#   sudo adduser deploy
#   sudo adduser deploy sudo
#   su deploy
#   EOF
#   user "root"

#   not_if { `bash -c "id -u deploy"`.lines[0].to_i > 0 }
# end


user 'deploy' do
  comment 'deploy user'
  # uid '1234'
  # gid '1234'
  home '/home/deploy'
  shell '/bin/bash'
  password '$1$JJsvHslasdfjVEroftprNn4JHtDi'
end