{% for vpc, args in pillar['vpcs'].iteritems()  %}
{{ vpc }}:
  boto_vpc.present:
    - name: {{ vpc }}
    {% set vpcprefix = args['prefix'] %}
    - cidr_block: {{ args['prefix'] }}.0.0/{{ args['mask'] }}
    - dns_hostnames: true
    - region: {{ pillar['region'] }}

igw-{{ vpc }}:
  boto_vpc.internet_gateway_present:
    - name: igw-{{ vpc }}
    - vpc_name: {{ vpc }}
    - region: {{ pillar['region'] }}

  {% for subnet, args in pillar['subnets'].iteritems() %}
{{ subnet }}-{{ vpc }}:
  boto_vpc.subnet_present:
    - name: {{ subnet }}-{{ vpc }}
    - cidr_block: {{ vpcprefix }}.{{ loop.index }}.0/{{ args['mask'] }}
    - vpc_name: {{ vpc }}
    - availability_zone: {{ args['az'] }}
    - region: {{ pillar['region'] }}
  {% endfor %}

rt-{{ vpc }}:
  boto_vpc.route_table_present:
    - name: rt-{{ vpc }}
    - vpc_name: {{ vpc }}
    - routes:
      - destination_cidr_block: 0.0.0.0/0
        internet_gateway_name: igw-{{ vpc }}
    - subnet_names:
  {% for subnet in pillar['subnets'] %}
      - {{ subnet }}-{{ vpc }}
  {% endfor %}
    - region: {{ pillar['region'] }}
{% endfor %}
