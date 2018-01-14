# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
  echo 'hellooooooo'
  su deploy

  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt-get update
  sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn

  cd
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  exec $SHELL

  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  exec $SHELL

  rbenv install 2.5.0
  rbenv global 2.5.0
  ruby -v

  gem install bundler


  EOF
  user "root"

end



execute "Install rbenv and ruby -- debug" do
  # command "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"
  command "echo 'hellooooooo2'"
  user "root"
end

bash "create test folder 1" do
  code "mkdir -p /home/deploy/folder1"
  user "deploy"
end

bash "create test folder 2" do
  code <<-EOF
    mkdir -p /home/deploy/folder2
  EOF
  user "deploy"
end