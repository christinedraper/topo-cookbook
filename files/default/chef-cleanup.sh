#!/bin/sh
if [ -f "/etc/chef/client.rb" ]; then
  chef-client -o topo::run_chef_cleanup > /var/log/chef-cleanup.log 2>&1
fi
