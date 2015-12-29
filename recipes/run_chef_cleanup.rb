#
# Cookbook Name:: topo
# Recipe:: run_chef_cleanup
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
# This recipe deletes the node from Chef and cleans up keys that give access to
# Chef.

# This recipe should be run using an override runlist, as
# results cannot be saved to the server once the node is deleted.
# Note, report handlers will also fail.
#

name = node.name

chef_node name do
  action :delete
end

chef_client name do
  action :delete
end

# reset other files so node can be imaged and bootstrapped
file '/etc/chef/client.pem' do
  action :delete
end

file '/etc/chef/validation.pem' do
  action :delete
  only_if { node['topo']['delete_validation_key'] == 'shutdown' }
end
