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
