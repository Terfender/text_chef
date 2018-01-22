# Install rbenv and ruby
ruby_version  = '2.5.0'
rbenv_path    = '/home/ubuntu/.rbenv'
rbenv         = "#{rbenv_path}/bin/rbenv"

bash "Install rbenv and ruby" do
  code <<-EOF
  
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update
    sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn
    

    if [ -d '#{rbenv_path}' ]
    then
        echo "'#{rbenv_path}' already exists"
    else
      git clone https://github.com/rbenv/rbenv.git '#{rbenv_path}'
      echo 'export PATH="'#{rbenv_path}'/bin:$PATH"' >> /home/ubuntu/.bashrc
      echo 'eval "$(rbenv init -)"' >> /home/ubuntu/.bashrc
    fi

    if [ -d '#{rbenv_path}'/plugins/ruby-build ]
    then
        echo "'#{rbenv_path}'/plugins/ruby-build already exists"
    else
      git clone https://github.com/rbenv/ruby-build.git '#{rbenv_path}'/plugins/ruby-build
      echo 'export PATH="'#{rbenv_path}'/plugins/ruby-build/bin:$PATH"' >> /home/ubuntu/.bashrc
    fi

    source /home/ubuntu/.bashrc
    echo 'exec done'
    #exec -l $SHELL


    if [ -d '#{rbenv_path}'/versions/#{ruby_version} ]
    then
        echo "version '#{ruby_version}' already installed"
    else
      '#{rbenv}' install #{ruby_version}
    fi
    
    '#{rbenv}' global #{ruby_version}

    '#{rbenv_path}'/shims/ruby -v

    sudo -u ubuntu '#{rbenv_path}'/shims/gem install bundler

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end