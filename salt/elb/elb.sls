dev-elb:
  boto_elb.present:
    - name: dev-elb
    - subnet_names:
        - subAppA-dev
        - subAppB-dev
        - subAppC-dev
    - security_groups:
        - sgElb-dev
    - listeners:
        - elb_port: 80
          instance_port: 80
          elb_protocol: HTTP
          instance_protocol: HTTP
    - health_check:
        target: 'TCP:80'
    - attributes:
        cross_zone_load_balancing:
          enabled: true
        connection_draining:
          enabled: true
          timeout: 30
    - region: us-west-2
