#
# Cookbook Name:: topo
# Spec:: setup_node
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
require 'spec_helper'

topo1 = {
  'name' => 'test',
  'id' => 'test',
  'nodes' => [
    {
      'name' => 'node1',
      'attributes' => {
        'topo' => { 'node_type' => 'appserver' }
      },
      'tags' => ['tag2'],
      'run_list' => ['recipe[appserver]']
    },
    {
      'name' => 'chefspec',
      'normal' => {
        'topo' => { 'node_type' => 'dbserver' },
        'testapp' => { 'version' => '0.1.1' }
      },
      'tags' => ['tag3'],
      'run_list' => ['recipe[apt]'],
      'chef_environment' => 'test'
    }
  ]
}

topo1_item =  Chef::DataBagItem.from_hash(topo1)

topo2 = {
  'name' => 'test',
  'id' => 'test',
  'tags' => %w(tag1 tag2),
  'attributes' => {
    'testapp' => { 'version' => '0.1.3' }
  },
  'chef_environment' => 'test',
  'nodes' => [
    {
      'name' => 'node1',
      'attributes' => {
        'topo' => { 'node_type' => 'appserver' }
      },
      'tags' => ['tag3'],
      'run_list' => ['recipe[apt]']
    },
    {
      'name' => 'node2',
      'attributes' => {
        'topo' => { 'node_type' => 'dbserver' }
      },
      'tags' => ['tag4'],
      'run_list' => ['recipe[db]']
    }
  ]
}
topo2_item =  Chef::DataBagItem.from_hash(topo2)

describe 'topo::setup_node' do
  context 'When topo and node name match' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['topo']['name'] = 'test'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_return(topo1_item)
      runner.converge(described_recipe)
    end

    it 'sets node by name and topo' do
      expect(chef_run).to create_chef_node('chefspec').with(
        'chef_environment' => 'test',
        'attributes' => {
          'topo' => { 'name' => 'test',  'node_type' => 'dbserver' },
          'testapp' => { 'version' => '0.1.1' },
          'tags' => ['tag3']
        },
        'run_list' => ['recipe[apt]']
      )
    end
  end

  context 'When node type and blueprint matches' do
    let(:response_404) { OpenStruct.new(code: '404') }
    let(:exception_404) do
      Net::HTTPServerException.new('404 not found', response_404)
    end
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['topo']['name'] = 'test2'
      runner.node.set['topo']['blueprint_name'] = 'test'
      runner.node.set['topo']['node_type'] = 'appserver'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test2').and_raise(exception_404)
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_return(topo2_item)
      runner.converge(described_recipe)
    end

    it 'sets node by type and blueprint' do
      expect(chef_run).to create_chef_node('chefspec').with(
        'chef_environment' => 'test',
        'attributes' => {
          'topo' => { 'name' => 'test',  'node_type' => 'appserver' },
          'testapp' => { 'version' => '0.1.3' },
          'tags' => %w(tag3 tag1 tag2)
        },
        'run_list' => ['recipe[apt]']
      )
    end
  end
end
