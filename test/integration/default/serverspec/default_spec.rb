require 'spec_helper'

describe 'topo::setup_node' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  context 'using topology' do
    it 'converges using test1 topology' do
      # Not clear how to test this
      skip 'Should have set node name to server1.example.com'
      skip 'Should have set runlist to include test1 cookbook'
    end
  end
end

describe 'topo::setup_chef_cleanup' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  context 'when run' do
    describe file('/etc/init.d/chef-cleanup.sh') do
      it { should be_file }
    end

    describe file('/etc/rc0.d/K04chef-cleanup') do
      it { should be_symlink }
    end
  end
end

describe 'topo::run_chef_cleanup' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  context 'when run' do
    describe file('/etc/chef/client.pem') do
      it { should_not exist }
    end

    describe file('/etc/chef/validation.pem') do
      it { should_not exist }
    end
  end
end
