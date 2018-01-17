include_recipe 'opsworks_ruby::deploy'

# include_recipe "deploy"
# Chef::Log.info('testing deployment')

# node[:deploy].each do |application, deploy|
#   Chef::Log.info(application)
#   Chef::Log.info(deploy)
#   Chef::Log.info('testing deployment2')
# end
# # include_recipe 'dependencies'

# node[:deploy].each do |application, deploy|

#   opsworks_deploy_user do
#     deploy_data deploy
#   end

# end
