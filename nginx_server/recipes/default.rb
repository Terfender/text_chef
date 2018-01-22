# Installing nginx and passenger
# Retrieved from https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/xenial/install_passenger.html
# In Jan 19, 2018
bash "Installing nginx" do
  code <<-EOF

    sudo apt-get install -y dirmngr gnupg
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates

    # Add our APT repository
    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update

    # Install Passenger + Nginx
    sudo apt-get install -y nginx-extras passenger
  EOF
  user "ubuntu"
end



cookbook_file "Copy nginx.conf" do
  group "root"
  mode "0644"
  owner "root"
  path "/etc/nginx/nginx.conf"
  cookbook 'nginx_server'
  source "nginx.conf"  
end



cookbook_file "Copy adstash server configs" do
  group "root"
  mode "0644"
  owner "root"
  path "/etc/nginx/sites-available/adstash"
  cookbook 'nginx_server'
  source "adstash"  
end



cookbook_file "Copy passenger.conf" do
  group "root"
  mode "0644"
  owner "root"
  path "/etc/nginx/passenger.conf"
  cookbook 'nginx_server'
  source "passenger.conf"  
end



bash "enabled adstash server config" do
  code <<-EOF
    rm /etc/nginx/sites-enabled/adstash
    ln -s /etc/nginx/sites-available/adstash /etc/nginx/sites-enabled/adstash

    # remove default
    rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
  EOF
  user "root"
end



bash "create ping test dir" do
  code <<-EOF
    mkdir -p /home/ubuntu/apps/elb_ping
    sudo chown -R ubuntu:ubuntu /home/ubuntu/apps/elb_ping
  EOF
  user "root"
end



cookbook_file "copy ELB ping test" do
  group "root"
  mode "0644"
  owner "ubuntu"
  path "/home/ubuntu/apps/elb_ping/index.html"
  cookbook 'nginx_server'
  source "elb_ping.html"  
end



bash "Restart nginx to pick up configs changes" do
  code "sudo service nginx restart"
  user "root"
end
