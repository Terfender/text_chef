# Initializers
deploy_root     = '/home/ubuntu/apps'
app             = search("aws_opsworks_app").first
data_sources    = search("aws_opsworks_rds_db_instance")
environment     = app['environment']
app_name        = app['name'] #'AdSatash'
revision        = app['app_source']['revision'] ? "-b #{app['app_source']['revision']}" : ''
ssh_key         = app['app_source']['ssh_key']
git_url         = app['app_source']['url']
releases_dir    = "#{deploy_root}/#{app_name}/releases"
current_release = "#{deploy_root}/#{app_name}/current"
shared_dir      = "#{deploy_root}/#{app_name}/shared"
git_dir         = "#{releases_dir}/#{Time.now.to_s.gsub(/\D+/, '')[0,13]}"
tmp_key_path    = "#{deploy_root}/#{app_name}/key"
ssh_config      = '/etc/ssh/ssh_config'
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
  ssh-agent bash -c 'ssh-add '#{tmp_key_path}'; git clone #{revision} #{git_url} '#{git_dir}''
`



# link shared dir & current_release
`
  rm -rf '#{current_release}'
  ln -s '#{git_dir}' '#{current_release}'

  rm -rf '#{current_release}/bin'
  ln -s '#{shared_dir}/bin' '#{current_release}/bin'

  rm -rf '#{current_release}/log'
  ln -s '#{shared_dir}/log' '#{current_release}/log'

  rm -rf '#{shared_dir}/config/secrets.yml.key' '#{current_release}/config/secrets.yml.key'
  echo #{environment['ADSTASH_APP_SECRET']} >> '#{shared_dir}/config/secrets.yml.key'
  ln -s '#{shared_dir}/config/secrets.yml.key' '#{current_release}/config/secrets.yml.key'
`



# clone adstash engines
engines = [
  {
    name:         'ad_finance',
    url:          'git@bitbucket.org:linkett/adfinance.git',
    revision:     'master',
    env_secret:   '',
  },
  {
    name:         'ad_stash',
    url:          'git@bitbucket.org:linkett/adstash_api.git',
    revision:     'master',
    env_secret:   'ADSTASH_API_SECRET',
  }
]
engines.each do |engine|
  dir     = "#{git_dir}/engines/#{engine[:name]}"
  secret  = environment[engine[:env_secret]]
  `
    ssh-agent bash -c 'ssh-add #{tmp_key_path}; git clone -b #{engine[:revision]} #{engine[:url]} #{dir}'
  `
  if secret
    `
      rm -rf '#{dir}/config/secrets.yml.key'
      echo #{secret} >> '#{dir}/config/secrets.yml.key'
    `
  end
end



# Configure Data Source
data_source = nil
app_arn     = nil
app['data_sources'].each do |source|
  # we are looking for RDS instances
  next if source['type'] != 'RdsDbInstance'
  # we only look for "one" ARN that hooked to this app
  # cuz each app has only one data source (as it's setup on OpsWorks UI)
  app_arn = source['arn'] if app_arn.nil?
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
      password:   data_source['db_password']
  })
end



# create symbolic link to database.yml
`
  rm -rf '#{shared_dir}/config/database.yml' '#{current_release}/config/database.yml'
  ln -s '#{shared_dir}/config/database.yml' '#{current_release}/config/database.yml'
`



# bundle app gems
`
  cd '#{current_release}'' &&  /home/ubuntu/.rbenv/shims/bundle install --without development test
`



# clean up
`
  sudo chown -R ubuntu:ubuntu #{git_dir}
  rm '#{tmp_key_path}'

  # To remove the last line added to ssh_config
  sed '$ d' '#{ssh_config}' &> '#{ssh_config}'
`



# run migration
bash "run migration" do
  cwd current_release
  code <<-EOF
    /home/ubuntu/.rbenv/shims/bundle exec rake db:migrate RAILS_ENV=production
  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})
end



# restart app
# recommended way according to https://www.phusionpassenger.com/library/admin/apache/restart_app.html
`
  passenger-config restart-app '#{current_release}'
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
