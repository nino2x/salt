# is only used by cidr_ip in security groups
{% set cidr_global = '10.0.0.0/8' %}

aws:
  region:
# region is only specified here since each region has a different number of availability zones for subnets
    us-west-2:
      vpc:
# generates any number of identical VPCs named on vpc_list
{% set vpc_list = ['dev', 'stage'] %}
{% for vpc_name in vpc_list %}
        {{ vpc_name }}:
          cidr_prefix: '10.{{ loop.index }}'
          vpc:
            name: {{ vpc_name }}
            cidr_block: '10.{{ loop.index }}.0.0/16'
            dns_support: 'true'
            dns_hostnames: 'true'
          internet_gateway:
            name: igw-{{ vpc_name }}
          subnets:
# generates any number of named subnets in all listed availability zones
  {% set subnet_list = ['subApp', 'subRds'] %}
  {% set az_list = ['a', 'b', 'c'] %}
  {% for subnet_name in subnet_list %}
    {% set subnet_number = loop.index %}
    {% for az_letter in az_list %}
            {{ subnet_name + az_letter|upper }}:
              az: '{{ az_letter }}'
              subnet_number: '{{ subnet_number ~ loop.index }}'
# ----------
# NAT gateway attempt
#      {# if subnet_number == 1 #}
#      {# if subnet_name == 'subWeb' #}
#              nat_gateway: true
#      {# endif #}
# ----------
    {% endfor %}
  {% endfor %}
# creates NAT gateway in specified subnet
          nat_gateway:
            subnet_name: subAppA
# creates routing tables
          routing_tables:
            app_route:
              routes:
                internet:
                  destination_cidr_block: '0.0.0.0/0'
                  internet_gateway_name: igw-{{ vpc_name }}
                peering:
                  destination_cidr_block: '10.0.0.0/16'
                  vpc_peering_connection_name: {{ vpc_name }}-to-salt-master
# ----------
# alternative to vpc_peering_connection_name
#                  vpc_peering_connection_id: pcx-a434a9cd
# ----------
              subnet_names:
                - subAppA
                - subAppB
                - subAppC
            rds_route:
              routes:
                internet:
                  destination_cidr_block: '0.0.0.0/0'
                  nat_gateway_subnet_name: subAppA-{{ vpc_name }}
                peering:
                  destination_cidr_block: '10.0.0.0/16'
                  vpc_peering_connection_name: {{ vpc_name }}-to-salt-master
              subnet_names:
                - subRdsA
                - subRdsB
                - subRdsC
# creates security groups
          security_groups:
            sgBase:
              description: Base SG
              rules:
                all-ingress:
                  ip_protocol: all
                  port: -1
                  cidr_ip: {{ cidr_global }}
              rules_egress:
                all-egress:
                  ip_protocol: all
                  port: -1
                  cidr_ip: '0.0.0.0/0'
            sgApp:
              description: App SG
              rules:
                http-ingress:
                  ip_protocol: tcp
                  port: 80
                  cidr_ip: '0.0.0.0/0'
                https-ingress:
                  ip_protocol: tcp
                  port: 443
                  cidr_ip: '0.0.0.0/0'
                elb-http-ingress:
                  ip_protocol: tcp
                  port: 80
                  source_group_name: sgElb
                elb-https-ingress:
                  ip_protocol: tcp
                  port: 443
                  source_group_name: sgElb
            sgRds:
              description: RDS SG
              rules:
                db-access:
                  ip_protocol: tcp
                  port: 3306
                  source_group_name: sgApp
            sgElb:
              description: Elb SG
              rules:
                http-ingress:
                  ip_protocol: tcp
                  port: 80
                  cidr_ip: '0.0.0.0/0'
                https-ingress:
                  ip_protocol: tcp
                  port: 443
                  cidr_ip: '0.0.0.0/0'
{% endfor %}
