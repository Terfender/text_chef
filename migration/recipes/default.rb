deploy_root     = '/home/ubuntu/apps'
app             = search("aws_opsworks_app").first
app_name        = app['name'] #'AdSatash'
current_release = "#{deploy_root}/#{app_name}/current"

Chef::Log.warn('----------------------')
Chef::Log.warn(node['secrets'])

# `cd #{current_release} && bundle exec rake assets:precompile db:migrate RAILS_ENV=production`