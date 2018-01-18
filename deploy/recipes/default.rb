deploy_root     = '/home/ubuntu/apps'
app             = search("aws_opsworks_app").first
app_name        = app['name'] #'AdSatash'
revision        = app['app_source']['revision'] ? "-b #{app['app_source']['revision']}" : ''
ssh_key         = app['app_source']['ssh_key']
git_url         = app['app_source']['url']
releases_dir    = "#{deploy_root}/#{app_name}/releases"
current_release = "#{deploy_root}/#{app_name}/current"
git_dir         = "#{releases_dir}/#{Time.now.to_s.gsub(/\D+/, '')[0,13]}"
tmp_key_path    = "#{deploy_root}/#{app_name}/key"
ssh_config      = '/etc/ssh/ssh_config'
keep_releases   = 5

`mkdir #{deploy_root}` if !File.directory?("#{deploy_root}")

if !File.directory?("#{deploy_root}/#{app_name}")
  `
  cd #{deploy_root}
  mkdir #{app_name}
  cd #{app_name}
  mkdir releases shared
  cd shared
  mkdir bin bundle config log public tmp vendor
  `
end

# keep only @keep_releases releases
server_releases = 0
releases_dirs   = []
Dir.foreach(releases_dir) do |item|
  next if item == '.' or item == '..'
  releases_dirs << item.to_i
end


if releases_dirs.count > keep_releases
  releases_dirs.sort.take(keep_releases).each do |release|
    `rm -rf #{releases_dir}/#{release}`
  end
end


output = File.open(tmp_key_path, 'w')
output << ssh_key
output.close


`
# To skip adding host fingerprint
echo "StrictHostKeyChecking no" >> #{ssh_config}

chmod 400 #{tmp_key_path}

ssh-agent bash -c 'ssh-add #{tmp_key_path}; git clone #{revision} #{git_url} #{git_dir}'

rm #{tmp_key_path}

# To remove the last line added to ssh_config
tail -n 1 '#{ssh_config}' | wc -c | xargs -I {} truncate '#{ssh_config}' -s -{}

ln -s '#{git_dir}' '#{current_release}'
`

def release_dir
  Time.now.to_s.gsub(/\D+/, '')[0,13]
end