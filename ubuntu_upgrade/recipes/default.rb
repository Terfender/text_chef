# Install basic packages
%w(git build-essential curl libcurl4-openssl-dev libpcre3 libpcre3-dev).each do |pkg|
  apt_package pkg
end


# updates the list of available packages and their versions, 
# but it does not install or upgrade any packages
# source: https://askubuntu.com/a/94104
execute "apt-get update" do
  command "apt-get update"
  user "root"
end



# actually installs newer versions of the packages you have. 
# After updating the lists, the package manager knows about available updates for the software you have installed.
# source: https://askubuntu.com/a/94104
execute "apt-get upgrade" do
  command "apt-get upgrade"
  user "root"
end
