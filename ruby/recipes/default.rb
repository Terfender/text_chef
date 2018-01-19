# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
  
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update
    sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn
    
    cd /home/ubuntu

    if [ -d /home/ubuntu/.rbenv ]
    then
        echo "/home/ubuntu/.rbenv already exists"
    else
      git clone https://github.com/rbenv/rbenv.git /home/ubuntu/.rbenv
      echo 'export PATH="/home/ubuntu/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc
      echo 'eval "$(rbenv init -)"' >> /home/ubuntu/.bashrc
    fi

    if [ -d /home/ubuntu/.rbenv/plugins/ruby-build ]
    then
        echo "/home/ubuntu/.rbenv/plugins/ruby-build already exists"
    else
      git clone https://github.com/rbenv/ruby-build.git /home/ubuntu/.rbenv/plugins/ruby-build
      echo 'export PATH="/home/ubuntu/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/ubuntu/.bashrc
    fi

    source /home/ubuntu/.bashrc
    echo 'exec done'
    #exec -l $SHELL

    /home/ubuntu/.rbenv/bin/rbenv install 2.5.0
    /home/ubuntu/.rbenv/bin/rbenv global 2.5.0
    ruby -v

    /home/ubuntu/.rbenv/shims/gem install bundler

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end