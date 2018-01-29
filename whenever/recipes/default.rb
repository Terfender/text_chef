# Initializers
deploy_root       = '/home/ubuntu/apps'
app               = search("aws_opsworks_app").first
app_name          = app['name'] #'AdStash'
current_release   = "#{deploy_root}/#{app_name}/current"
instances         = search("aws_opsworks_instance")
online_instances  = instances.select{ |instance| instance['status'] == 'online'}
instance          = instances.sort_by{ |instance| instance['instance_id'] }.first
bundle_path       = '/home/ubuntu/.rbenv/shims/bundle'



if instance['self']
  Chef::Log.warn('This instance will run Whenever')
  bash "run whenver" do
    cwd current_release
    code <<~EOF
      '#{bundle_path}' exec whenever --update-crontab --set environment='production' --set path='#{current_release}'
    EOF
    user "ubuntu"
    environment ({'HOME' => '/home/ubuntu'})
  end
else
  Chef::Log.warn('This instance will NOT run Whenever')
end
