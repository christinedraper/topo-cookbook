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
  'name' => 'test1',
  'id' => 'test1',
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

blueprint = {
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
blueprint_item =  Chef::DataBagItem.from_hash(blueprint)

describe 'topo::setup_node' do
  let(:response_404) { OpenStruct.new(code: '404') }
  let(:exception_404) do
    Net::HTTPServerException.new('404 not found', response_404)
  end

  context 'When topo and node name match' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test1'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test1').and_return(topo1_item)
      runner.converge(described_recipe)
    end

    it 'sets node by name and topo' do
      expect(chef_run).to create_chef_node('chefspec').with(
        'chef_environment' => 'test',
        'attributes' => {
          'topo' => { 'name' => 'test1',  'node_type' => 'dbserver' },
          'testapp' => { 'version' => '0.1.1' },
          'tags' => ['tag3']
        },
        'run_list' => ['recipe[apt]']
      )
    end
  end

  context 'When node type and blueprint matches' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test2'
      runner.node.override['topo']['blueprint_name'] = 'test'
      runner.node.override['topo']['node_type'] = 'appserver'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test2').and_raise(exception_404)
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_return(blueprint_item)
      runner.converge(described_recipe)
    end

    it 'sets node by type and blueprint' do
      expect(chef_run).to create_chef_node('chefspec').with(
        'chef_environment' => 'test',
        'attributes' => {
          'topo' => {
            'name' => 'test2',
            'node_type' => 'appserver',
            'blueprint_name' => 'test'
          },
          'testapp' => { 'version' => '0.1.3' },
          'tags' => %w(tag3 tag1 tag2)
        },
        'run_list' => ['recipe[apt]']
      )
    end

    it 'does not delete validation key' do
      expect(chef_run).not_to delete_file('/etc/chef/validation.pem')
    end
  end

  context 'When node type is specified in v2 format' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test3'
      runner.node.override['topo']['blueprint_name'] = 'test'
      runner.node.override['topo']['node_type'] = 'dbserver'
      allow(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test3').and_raise(exception_404)
      allow(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_return(blueprint_item)
      runner.converge(described_recipe)
    end

    it 'sets node by type and topo' do
      expect(chef_run).to create_chef_node('chefspec').with(
        'chef_environment' => 'test',
        'attributes' => {
          'topo' => {
            'name' => 'test3',
            'node_type' => 'dbserver',
            'blueprint_name' => 'test'
          },
          'testapp' => { 'version' => '0.1.3' },
          'tags' => %w(tag4 tag1 tag2)
        },
        'run_list' => ['recipe[db]']
      )
    end
  end

  context 'When there is no matching data bag' do
    let(:response_404) { OpenStruct.new(code: '404') }
    let(:exception_404) do
      Net::HTTPServerException.new('404 not found', response_404)
    end
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test2'
      runner.node.override['topo']['blueprint_name'] = 'test'
      runner.node.override['topo']['node_type'] = 'appserver'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test2').and_raise(exception_404)
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_raise(exception_404)
      runner.converge(described_recipe)
    end

    it 'does not raise an error' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When delete_validation_key is setup' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test'
      runner.node.override['topo']['delete_validation_key'] = 'setup'
      expect(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test').and_return(topo1_item)
      runner.converge(described_recipe)
    end

    it 'deletes validation key after setup' do
      expect(chef_run).to delete_file('/etc/chef/validation.pem')
    end
  end
end
