topo Cookbook
=============

This cookbook supports unattended bootstrap of nodes when 
using the [knife-topo plugin](https://github.com/christinedraper/knife-topo) 
to configure single or multi-node topologies.
This can be useful in combination with CloudFormation or other 
provisioning tools.

The [source for this cookbook](https://github.com/christinedraper/topo-cookbook) is on Github.

#setup_node recipe

Upload a topology definition to the Chef Server using knife-topo:

```
knife topo import test1.json
knife topo create test1
```

Use a single attribute in a first-boot json file of each node to specify 
the topology name, and optionally a node type:

```
firstboot.json
{
  "topo": {
    "name": "test1",
    "node_type": "appserver"
  }
}
```

Trigger the unattended bootstrap by running: 

```
chef-client -o topo::setup_node --json firstboot.json
chef-client
```

The first chef-client run will set the configuration (runlist, chef
environment, tags and attributes) based on the uploaded topology
and either the node name or the node type; the second run will apply 
that configuration.

#setup_chef_cleanup recipe

Use the 'setup_chef_cleanup' recipe to create a script that will invoke 
the run_chef_cleanup recipe when the node is shutdown. 

This recipe is platform-specific has only been tested on Ubuntu 14.04.

#run_chef_cleanup recipe

Use the 'run_chef_cleanup' recipe to delete the chef node and client from 
the Chef server, and also delete the validation and client keys.

To keep the validation key, set `node['topo']['delete_validation_key']` 
to `never`.

#Attributes

* `node['topo']['name']` - Name of the topology to be used to configure 
the node
* `node['topo']['node_type']` - If node.name is not found in the 
topology, then this attribute will be used to find a match.
* `node['topo']['blueprint_name']` - If no topology data bag item matching
`node['topo']['name']` is found, then this attribute is used as an 
alternative.

# License 

Author:: Christine Draper (christine_draper@thirdwaveinsights.com)

Copyright:: Copyright (c) 2015 ThirdWave Insights, LLC

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 
