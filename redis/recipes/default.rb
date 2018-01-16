# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
    sudo apt-get update -y
    sudo apt-get install -y build-essential
    sudo apt-get install tcl8.5

    cd /home/ubuntu
    wget http://download.redis.io/releases/redis-stable.tar.gz
    tar xzf redis-stable.tar.gz

    cd redis-stable
    make
    make test
    sudo make install

    cd utils
    sudo ./install_server.sh
    sudo service redis_6379 start
    sudo update-rc.d redis_6379 defaults

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end