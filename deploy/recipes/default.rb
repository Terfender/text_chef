# Initializers
deploy_root     = '/home/ubuntu/apps'
app             = search("aws_opsworks_app").first
data_sources    = search("aws_opsworks_rds_db_instance")
environment     = app['environment']
app_environment = app['environment']['APP_ENVIRONMENT'] ? app['environment']['APP_ENVIRONMENT'] : 'production'
app_name        = app['name']
revision        = app['app_source']['revision'] ? app['app_source']['revision'] : 'master'
ssh_key         = app['app_source']['ssh_key']
git_url         = app['app_source']['url']
releases_dir    = "#{deploy_root}/#{app_name}/releases"
current_release = "#{deploy_root}/#{app_name}/current"
shared_dir      = "#{deploy_root}/#{app_name}/shared"
git_dir         = "#{releases_dir}/#{Time.now.to_s.gsub(/\D+/, '')[0,13]}"
tmp_key_path    = "#{deploy_root}/#{app_name}/key"
ssh_config      = '/etc/ssh/ssh_config'
bundle_path     = '/home/ubuntu/.rbenv/shims/bundle'
keep_releases   = 5



# Make dir for the app
`mkdir '#{deploy_root}'` if !File.directory?("#{deploy_root}")



# prepare new dirs for a new app
if !File.directory?("#{deploy_root}/#{app_name}")
  `
  cd '#{deploy_root}'
  mkdir '#{app_name}'
  cd '#{app_name}'
  mkdir releases shared
  cd shared
  mkdir bin bundle config log public tmp vendor
  sudo chown -R ubuntu:ubuntu '#{deploy_root}/#{app_name}'
  `
end




# Write ssh_key to a temp file
File.write(tmp_key_path, ssh_key)



# To skip adding host fingerprint
`
  echo "StrictHostKeyChecking no" >> '#{ssh_config}'
  chmod 400 #{tmp_key_path}
`



# clone adstash-app repo
`
  ssh-agent bash -c 'ssh-add '#{tmp_key_path}'; git clone -b #{revision} #{git_url} '#{git_dir}''
`



# clone adstash engines
engines = [
  {
    name:         'ad_finance',
    url:          'git@bitbucket.org:linkett/adfinance.git',
    env_secret:   '',
  },
  {
    name:         'ad_stash',
    url:          'git@bitbucket.org:linkett/adstash_api.git',
    env_secret:   'ADSTASH_API_SECRET',
  }
]
engines.each do |engine|
  dir     = "#{git_dir}/engines/#{engine[:name]}"
  secret  = environment[engine[:env_secret]]
  `
    ssh-agent bash -c 'ssh-add #{tmp_key_path}; git clone -b #{revision} #{engine[:url]} #{dir}'
  `
  if secret
    `
      rm -rf '#{dir}/config/secrets.yml.key'
      echo #{secret} >> '#{dir}/config/secrets.yml.key'
    `
  end
end



# Configure Data Source
data_source     = nil
app_arn         = nil
database_name   = nil
app['data_sources'].each do |source|
  # we are looking for RDS instances
  next if source['type'] != 'RdsDbInstance'
  # we only look for "one" ARN that hooked to this app
  # cuz each app has only one data source (as it's setup on OpsWorks UI)
  if app_arn.nil?
    app_arn       = source['arn']
    database_name = source['database_name']
  end
end

data_sources.each do |source|
  # loop trough all RDS layers and find ARN of app DB instance
  data_source = source if source['rds_db_instance_arn'] == app_arn
end

template "database.yml" do
  source "database.yml.erb"
  path "#{shared_dir}/config/database.yml"
  owner 'ubuntu'
  cookbook 'deploy'
  group 'ubuntu'
  variables({
      host:       data_source['address'],
      port:       data_source['port'],
      username:   data_source['db_user'],
      password:   data_source['db_password'],
      database:   database_name
  })
end



# link shared dir & current_release
`
  rm '#{shared_dir}/config/secrets.yml.key'
  echo #{environment['ADSTASH_APP_SECRET']} >> '#{shared_dir}/config/secrets.yml.key'
  ln -fs '#{shared_dir}/config/secrets.yml.key' '#{git_dir}/config/secrets.yml.key'

  ln -fs '#{shared_dir}/config/database.yml' '#{git_dir}/config/database.yml'

  rm -rf '#{git_dir}/log'
  ln -nfs '#{shared_dir}/log'    '#{git_dir}/log'

  ln -nfs '#{git_dir}'           '#{current_release}'
`



log('running bulde intall')
# bundle app gems
bash "bundle app gems" do
  cwd git_dir
  code <<-EOF
    '#{bundle_path}' install #--without development test
  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end


log('running assets precompile')
# precompile assets
bash "precompile assets" do
  cwd git_dir
  code <<-EOF
    '#{bundle_path}' exec rake assets:precompile RAILS_ENV='#{app_environment}'
  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end



# run migration
include_recipe 'migrations'



# give ubuntu full access to git_dir
`
  sudo chown -R ubuntu:ubuntu #{git_dir}
`



# restart app
# recommended way according to https://www.phusionpassenger.com/library/admin/apache/restart_app.html
# and reload nginx
`
  sudo service nginx reload
  passenger-config restart-app '#{current_release}'
`



# Run Sidekiq as daemon
bash "Run Sidekiq as daemon" do
  cwd current_release
  code <<-EOF
    echo 'starting check sidekiq'

    if ps aux | grep '[s]idekiq'; then
      echo 'sidekiq is running'
    else
      echo 'sidekiq is not running'
      sudo '#{bundle_path}' exec sidekiq -d --environment '#{app_environment}' -l '#{current_release}'/log/sidekiq.log
    fi

    echo "finished sidekiq check"
  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end



# clean up
`
  rm '#{tmp_key_path}'

  # To remove the last line added to ssh_config
  sed '$ d' '#{ssh_config}' &> '#{ssh_config}'
`



# keep only @keep_releases releases
releases_dirs   = []
# get releases dirs
Dir.foreach(releases_dir) do |item|
  next if item == '.' or item == '..'
  releases_dirs << item.to_i
end

if releases_dirs.count > keep_releases
  releases_dirs.sort.take(keep_releases).each do |release|
    `rm -rf #{releases_dir}/#{release}`
  end
end


def log(msg)
  Chef::Log.warn(msg)
end