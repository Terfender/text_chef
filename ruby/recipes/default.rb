# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
    su deploy
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


# cookbook_file "install my lib" do
#   source "shell.sh"
#   mode 0755
# end

# execute "install my lib" do
#   command "sh /var/chef/cookbooks/ruby/files/default/shell.sh"
# end

# # Install RVM
# execute "Installing pubkey.gpg" do
#   command "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -"
#   user "deploy"
# end

# # Install rbenv
# execute "Installing rbenv and Ruby" do
#   command "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
#   user "deploy"
# end

# # Install basic packages
# %w(git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn).each do |pkg|
#   apt_package pkg
# end

# # git
# execute "git rbenv" do
#   command "git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
#   user "deploy"
# end
# bash "bashrc" do
#   code <<-EOF
#     echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
#   EOF
#   user "deploy"
# end
# bash "rbenv eval bashrc" do
#   code <<-EOF
#     echo 'eval "$(rbenv init -)"' >> ~/.bashrc
#   EOF
#   user "deploy"
# end
# execute "exec $SHELL" do
#   command "exec $SHELL"
#   user "deploy"
# end
# execute "rbenv install 2.5.0" do
#   command "rbenv install 2.5.0"
#   user "deploy"
# end
# execute "rbenv global 2.5.0" do
#   command "rbenv global 2.5.0"
#   user "deploy"
# end

