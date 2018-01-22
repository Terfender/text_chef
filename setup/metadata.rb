name        "Setup"
description "Installs setup recipes"
maintainer  "AdStash"
version     "1.0.0"

depends 'ubuntu_upgrade'
depends 'nginx_server'
depends 'ruby'
depends 'api_packages'
depends 'redis'
