Chef::Log.debug('testing deployment')

node[:deploy].each do |application, deploy|
  Chef::Log.debug(application)
  Chef::Log.debug(deploy)
  Chef::Log.debug('testing deployment2')
end
# include_recipe 'dependencies'

# node[:deploy].each do |application, deploy|

#   opsworks_deploy_user do
#     deploy_data deploy
#   end

# end
