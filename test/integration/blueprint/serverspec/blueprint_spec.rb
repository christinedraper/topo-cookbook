require 'spec_helper'

describe 'topo::setup_node' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  context 'using blueprint' do
    it 'converges using test topology' do
      skip 'Should have set runlist that includes blueprint_test cookbook'
    end
  end
end
