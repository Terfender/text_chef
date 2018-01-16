# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF

    echo 'check user'
    whoami
    echo $HOME

    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update
    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn
    sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
    
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

    echo 'exec ...'
    source /home/ubuntu/.bashrc
    echo 'exec done'
    # exec -l $SHELL

    echo '/home/ubuntu/.bashrc end'

    rbenv install 2.5.0
    rbenv global 2.5.0
    ruby -v

    gem install bundler

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end