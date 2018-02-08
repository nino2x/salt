SaltStack practice config
====
Overview
----
Salt state files:
- generate and apply a VPC config from a pillar
- generate and apply a security group config from a pillar
- create a MySQL RDS for Node.js app
- create an Elastic Load Balancer and apply instances to it
- install pyinotify and a beacon on a Salt minion
- copy and run Node.js apps on minions

Salt map files:
- create specific instances
- destroy specific instances

Salt Orchestrate Runner files:
- install, configure and run Node.js, the app, nginx reverse proxy and Elastic Load Balancer

Salt pillars:
- contains data used for creation of VPCs, subnets, NAT gateways, routing tables and security groups
