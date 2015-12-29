# topo.name is used to look for a topology data bag item
# topo.blueprint_name is used if no topology is found under topo.name
default['topo']['name'] = 'default'
default['topo']['blueprint_name'] = nil
default['topo']['topologies_data_bag'] = 'topologies'

# topo.node_type is used to look for node data if no data is
# found in the topology data bag item under node.name
default['topo']['node_type'] = 'default'

# when to delete the validation key ('setup', 'shutdown', 'never')
default['topo']['delete_validation_key'] = 'shutdown'
