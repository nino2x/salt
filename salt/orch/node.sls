# deploys 2 ec2 instances from a map file
deploy_instances:
  salt.runner:
    - name: cloud.map_run
    - path: /srv/salt/cloudmaps/test.map

# make sure nginx is installed and running
deploy_nginx:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - nginx

# make sure nodejs, dependecies and the app are installed and running
deploy_node:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - nodeapp

# deploys a load balancer
deploy_elb:
  salt.state:
    - tgt: 'local'
    - sls:
      - elb.elb

# set load balancer to this list of instances
{% set instances = salt['boto_ec2.find_instances'](filters={'vpc-id': 'vpc-ffdf2799'}, region='us-west-2') %}
set_elb_instances:
  salt.function:
    - name: boto_elb.set_instances
    - tgt: 'local'
    - arg:
      - dev-elb
    - kwarg:
        region: us-west-2
        instances:
          {% for instance in instances  %}
          - {{ instance }}
          {% endfor %}
