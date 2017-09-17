# set instance = salt['boto_ec2.get_id']('node-2a', region='us-west-2')
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
#          - i-0c56191c9473e6c22
#          - i-028cefba12a9d5e0a
