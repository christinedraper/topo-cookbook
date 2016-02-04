# topo Cookbook Changelog

##v0.1.2 (2015-12-01)

* Do not raise error when no topology data bag is found
* Set `node['topo']['name']` to the actual topology name, even if blueprint data bag is used 

##v0.1.3 (2015-12-28)

* Add recipes to cleanup the node, client and keys
* Add an example CloudFormation template that uses the recipes

##v0.1.4 (2016-02-02)

* Fix problem with look-up by node type

##v0.1.5 (2016-02-04)

* Add option to refresh attributes from topology data bag on each run.
* Store `blueprint_name` in normal node attribute, so can rerun `topo::setup_node`