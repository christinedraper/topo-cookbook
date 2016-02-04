#
# Cookbook Name:: topo
# Spec:: get_attributes
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
require 'spec_helper'

topo1 = {
  'name' => 'test1',
  'id' => 'test1',
  'nodes' => [
    {
      'name' => 'chefspec',
      'normal' => {
        'topo' => { 'node_type' => 'dbserver' },
        'one' => { 'a' => 'new_val' }
      }
    }
  ]
}

topo1_item =  Chef::DataBagItem.from_hash(topo1)

describe 'topo::refresh_attributes' do
  let(:response_404) { OpenStruct.new(code: '404') }
  let(:exception_404) do
    Net::HTTPServerException.new('404 not found', response_404)
  end

  context 'When refresh_attributes is true' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test1'
      runner.node.override['topo']['refresh_attributes'] = true
      runner.node.normal['one']['a'] = 'orig_val'
      runner.node.default['one']['b'] = 'orig_val'
      allow(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test1').and_return(topo1_item)
      runner.converge(described_recipe)
    end

    it 'sets node attributes' do
      expect(chef_run.node['one']['a']).to eq('new_val')
      expect(chef_run.node['one']['b']).to eq('orig_val')
    end
  end

  context 'When refresh_attributes is false and is in runlist' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test1'
      runner.node.override['topo']['refresh_attributes'] = false
      allow(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test1').and_return(topo1_item)
      runner.converge(described_recipe)
    end

    it 'raises an exception' do
      expect { chef_run }.to raise_error(
        "Set node['topo']['refresh_attributes'] to true")
    end
  end

  context 'When refresh_attributes is false is not in runlist' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['topo']['name'] = 'test1'
      runner.node.override['topo']['refresh_attributes'] = false
      runner.node.normal['one']['a'] = 'orig_val'
      runner.node.default['one']['b'] = 'orig_val'
      allow(Chef::DataBagItem).to receive(:load).with(
        'topologies',
        'test1').and_return(topo1_item)
      runner.converge('topo')
    end

    it 'does not set node attributes' do
      expect(chef_run.node['one']['a']).to eq('orig_val')
    end
  end
end
