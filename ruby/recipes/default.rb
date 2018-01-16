# # Install rbenv
# bash "Install rbenv" do
#   code <<-EOF

#     echo 'check user'
#     whoami
#     echo $HOME

#     curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

#     sudo apt-get update
#     sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev nodejs yarn
#     sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev

#     cd /home/ubuntu

#     if [ -d /home/ubuntu/.rbenv ]
#     then
#         echo "/home/ubuntu/.rbenv already exists"
#     else
#       git clone https://github.com/rbenv/rbenv.git /home/ubuntu/.rbenv
#       echo 'export PATH="/home/ubuntu/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc
#       echo 'eval "$(rbenv init -)"' >> /home/ubuntu/.bashrc
#     fi

#     if [ -d /home/ubuntu/.rbenv/plugins/ruby-build ]
#     then
#         echo "/home/ubuntu/.rbenv/plugins/ruby-build already exists"
#     else
#       git clone https://github.com/rbenv/ruby-build.git /home/ubuntu/.rbenv/plugins/ruby-build
#       echo 'export PATH="/home/ubuntu/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/ubuntu/.bashrc
#     fi

#     echo 'exec ...'
#     source /home/ubuntu/.bashrc # exec -l $SHELL
#     echo 'exec done'
    
#     echo '/home/ubuntu/.bashrc end'
#     exec -l $SHELL

#   EOF
#   user "ubuntu"
#   environment ({'HOME' => '/home/ubuntu'})

# end

# bash 'sourcing' do
#   code 'source /home/ubuntu/.bashrc'
#   user "ubuntu"
#   environment ({'HOME' => '/home/ubuntu'})
# end

execute 'Install ruby' do
  command 'rbenv install 2.5.0'
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end

execute 'global ruby' do
  command 'rbenv global 2.5.0'
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end

# # Install ruby
# bash "Install ruby" do
#   code <<-EOF
#     sudo -s
#     source /home/ubuntu/.bashrc
#     rbenv install 2.5.0
#     rbenv global 2.5.0
#     ruby -v

#     echo 'installing bundler'
#     gem install bundler
#     echo 'bundler done'

#   EOF
#   user "ubuntu"
#   environment ({'HOME' => '/home/ubuntu'})

# end
