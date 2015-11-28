#
# Cookbook Name:: topo
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
require 'chef/data_bag_item'

class Topo
  #
  class Node
    attr_reader :name, :attributes, :node_type
    attr_reader :chef_environment, :run_list, :tags

    def initialize(node_data)
      @name = node_data['name']
      @attributes = node_data['attributes'] || node_data['normal'] || {}
      @attributes['topo'] ||= {}
      @chef_environment = node_data['chef_environment']
      @run_list = node_data['run_list']
      @node_type = node_type
      @attributes['topo']['node_type'] ||= @node_type
      @attributes['tags'] = node_data['tags'] if node_data['tags']
    end

    def node_type
      type = @attributes['node_type']
      unless type
        if @attributes['topo']['node_type']
          type = @attributes['topo']['node_type']
        else
          type = 'unspecified'
        end
      end
      type
    end
  end
end
