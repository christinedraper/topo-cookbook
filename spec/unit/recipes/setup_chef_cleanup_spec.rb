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

describe 'topo::setup_chef_cleanup' do
  context 'When called with default attributes' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'creates shutdown script' do
      expect(chef_run).to render_file(
        '/etc/init.d/chef-cleanup.sh'
      ).with_content(/chef-client -o topo::run_chef_cleanup/)
    end

    it 'links shutdown script' do
      link = chef_run.link('/etc/rc0.d/K04chef-cleanup')
      expect(link).to link_to('/etc/init.d/chef-cleanup.sh')
    end
  end
end
