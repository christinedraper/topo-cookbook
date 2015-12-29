require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/topology'

def create_chef_node(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :chef_node,
    :create,
    resource_name)
end

def delete_chef_node(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :chef_node,
    :delete,
    resource_name)
end

def delete_chef_client(resource_name)
  ChefSpec::Matchers::ResourceMatcher.new(
    :chef_client,
    :delete,
    resource_name)
end
