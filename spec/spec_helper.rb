require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/topology'

def create_chef_node(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :chef_node,
    :create,
    resource_name)
end
