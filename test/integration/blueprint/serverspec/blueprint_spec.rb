require 'spec_helper'

describe 'topo::setup_node' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  context 'using blueprint' do
    it 'converges using test topology' do
      skip 'Should have  node name dbserver01'
      skip 'Should have set runlist to include blueprint-test cookbook'
    end
  end
end
