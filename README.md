# README

# Installation order for a new server:
  1- `ubuntu_upgrade::default`
  2- `nginx::default`
  3- `ruby::default`
  4- `api_packages::default`
  5- `redis::default`

  or run provide `ubuntu_upgrade::default,nginx::default,ruby::default,api_packages::default,redis::default` as a list and OpsWorks will run them in order


`deploy::default` is run when we hit "deploy" command in OpsWorks

# TO-DO:
  * `migration::default`