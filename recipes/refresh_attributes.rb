#
# Cookbook Name:: topo
# Recipe:: refresh_attributes
#
# Copyright (c) 2016 ThirdWave Insights, LLC.
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
# To refresh attributes from the topology on each chef run, include this
# recipe - or any topo recipe - in the runlist and set the attribute:
# node.override['topo']['refresh_attributes'] = true
#
# This does NOT set the runlist or chef environment (as
# this would require rerunning the chef-client from within the chef-client).
#
# The actual logic to refresh the attributes occurs in the attribute file,
# so that attributes are loaded at the expected time.
#
# The recipe cannot set the refresh_attributes attribute itself, as it
# would be too late in the execution flow. The purpose of this recipe is
# to ensure the node is configured the way you want.

unless node['topo']['refresh_attributes']
  raise("Set node['topo']['refresh_attributes'] to true")
end
