# trigger setup recipes
include_recipe 'ubuntu_upgrade'
include_recipe 'nginx_server'
include_recipe 'ruby'
include_recipe 'api_packages'
include_recipe 'redis'
