topo Cookbook
=============

This cookbook supports unattended bootstrap of nodes when 
using the [knife-topo plugin](https://github.com/christinedraper/knife-topo) 
to configure single or multi-node topologies.
This can be useful in combination with CloudFormation or other 
provisioning tools.

#Usage

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

#Attributes

* node['topo']['name'] - Name of the topology to be used to configure 
the node
* node['topo']['node_type'] - If node.name is not found in the 
topology, then this attribute will be used to find a match.
* node['topo']['blueprint_name'] - If no topology data bag item matching
node['topo']['name'] is found, then this attribute is used as an 
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
 
