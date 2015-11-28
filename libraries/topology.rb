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
require_relative './node'

class Topo
  # Handle topology data from data bag item
  class Topology
    @topos = {}

    # class method to get or create Topo instance
    def self.get_topo(topo_name, blueprint_name = nil,
      data_bag_name = 'topologies')

      unless @topos[topo_name]
        @topos[topo_name] = load_from_bag(topo_name, data_bag_name)

        # if specific topology doesnt exist, fallback to blueprint if specified
        unless @topos[topo_name]
          if blueprint_name
            @topos[topo_name] = load_from_bag(blueprint_name, data_bag_name)
          end
        end
      end

      @topos[topo_name]
    end

    def self.load_from_bag(topo_name, data_bag_name)
      begin
        raw_data = Chef::DataBagItem.load(data_bag_name, topo_name)
        topo = Topo::Topology.new(topo_name, raw_data.to_hash) if raw_data
      rescue Net::HTTPServerException => e
        raise unless e.to_s =~ /^404/
      end
      topo
    end

    def initialize(topo_name, raw_data)
      @topo_name = topo_name
      @raw_data = raw_data
      @nodes = []
      @chef_environment = @raw_data['chef_environment']
      @tags = @raw_data['tags']
      @attributes = @raw_data['attributes'] || @raw_data['normal'] || {}
      @raw_data['nodes'].each do |node_data|
        node = Topo::Node.new(inflate!(node_data))
        @nodes << node
      end if @raw_data['nodes']
    end

    # Expand each node in the JSON to contain a complete definition,
    # taking defaults from topology where not defined in the node json
    def inflate!(node_data)
      node_data['chef_environment'] ||= @chef_environment if @chef_environment
      if @tags
        node_data['tags'] ||= []
        node_data['tags'] |= @tags
      end
      node_data
    end

    def get_node(name, type = nil)
      node = @nodes.find do |n|
        n.name == name
      end

      if !node && type
        # if specific node doesn't exist, look for node of same type
        node = @nodes.find do |n|
          n.node_type == type
        end
      end

      node
    end
  end
end
