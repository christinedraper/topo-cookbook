#
# Cookbook Name:: topo
# Spec:: run_chef_cleanup
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

describe 'topo::run_chef_cleanup' do
  context 'When called with default attributes' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'deletes node and client' do
      expect(chef_run).to delete_chef_node('chefspec')
      expect(chef_run).to delete_chef_client('chefspec')
    end

    it 'deletes key files' do
      expect(chef_run).to delete_file('/etc/chef/client.pem')
      expect(chef_run).to delete_file('/etc/chef/validation.pem')
    end
  end

  context 'When delete_validation_key is not shutdown' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['topo']['delete_validation_key'] = 'never'
      runner.converge(described_recipe)
    end

    it 'does not delete validation key' do
      expect(chef_run).not_to delete_file('/etc/chef/validation.pem')
    end
  end
end
