# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF


    echo 'check user'
    whoami
    echo $HOME

    sudo mkdir /home/ubuntu/curl33
    echo 'dir created?'
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    sudo apt-get update
    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn




    cd
    git clone https://github.com/rbenv/rbenv.git /home/ubuntu/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc
    echo 'eval "$(rbenv init -)"' >> /home/ubuntu/.bashrc
    exec $SHELL

    git clone https://github.com/rbenv/ruby-build.git /home/ubuntu/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/ubuntu/.bashrc
    exec $SHELL

    rbenv install 2.5.0
    rbenv global 2.5.0
    ruby -v

    gem install bundler
  EOF
  user "ubuntu"

end
