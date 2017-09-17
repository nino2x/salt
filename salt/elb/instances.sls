{% set instances = salt['boto_ec2.find_instances'](filters={'vpc-id': 'vpc-ffdf2799'}, region='us-west-2') %}
add instances to elb:
  boto_elb.register_instances:
    - name: dev-elb
    - instances:
      {% for instance in instances  %}
      - {{ instance }}
      {% endfor %}
    - region: us-west-2
