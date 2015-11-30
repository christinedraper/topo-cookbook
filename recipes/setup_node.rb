#
# Cookbook Name:: topo
# Recipe:: setup_node
#
# Copyright (c) 2015 ThirdWave Insights, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Use this recipe to setup a node based on configuration in a topology json
#
# 1. Import and create a topology in the Chef Server using knife-topo
# knife topo import topology.json
# knife topo create test1
#
# 2. Setup client.rb file to include chef_server_url and node_name. Put
# validation key in /etc/chef/validation.pem.
#
# 3. Set the attributes topo.name in a firstboot json file
# {
#   "topo": {
#     "name": "test1",
#     "node_type": "appserver"
#    }
# }
#
# Optionally, specify topo.node_type and topo.blueprint_name. The recipe will
# look for node data based on topo.name and node.name first; and then using
# node_type. If no bag item is found for topo.name, it will look for a bag
# item called blueprint_name.
#
# 3. Run chef client with the -o option, so it does not store
# the current state.
#
# chef-client -o topo::setup_node -j firstboot.json
#
# 4. Then run chef-client again with no specified runlist
# to apply the configuration
#
# chef-client
#
#

topo_name = node['topo']['name']
node_type = node['topo']['node_type']
blueprint = node['topo']['blueprint_name']
topo = Topo::Topology.get_topo(topo_name, blueprint)

if topo
  topo_node = topo.get_node(node.name, node_type)

  if topo_node
    chef_node node.name do
      chef_environment topo_node.chef_environment if topo_node.chef_environment
      run_list topo_node.run_list if topo_node.run_list
      tags topo_node.tags if topo_node.tags
      attributes topo_node.attributes if topo_node.attributes
    end
  else
    looked_for = "node #{node.name}"
    looked_for << " or node type '#{node_type}'" if node_type
    Chef::Log.warn(
      "Unable to find #{looked_for} in topology '#{topo.name}' \
 so cannot configure node")
  end

else
  Chef::Log.warn(
    "Unable to find topology '#{topo.name}' so cannot configure node")
end
