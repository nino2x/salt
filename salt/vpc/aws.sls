{% set aws_data = salt['pillar.get']('aws', {}) %}

{% for region_name, region_data in aws_data.get('region', {}).items() %}
  {% for vpc_name, vpc_data in region_data.get('vpc', {}).items() %}
vpc_{{ vpc_name }}:
  boto_vpc.present:
    {% for key, value in vpc_data.get('vpc', {}).items() %}
    - {{ key }}: {{ value }}
    {% endfor %}
    - region: {{ region_name }}

igw_{{ vpc_name }}:
  boto_vpc.internet_gateway_present:
    - name: {{ vpc_data.get('internet_gateway').get('name') }}
    - vpc_name: {{ vpc_name }}
    - region: {{ region_name }}

    {% for subnet_name, subnet_data in vpc_data.get('subnets', {}).items() %}
subnet_{{ subnet_name }}_in_vpc_{{ vpc_name }}:
  boto_vpc.subnet_present:
    - name: {{ subnet_name }}-{{ vpc_name }}
    - vpc_name: {{ vpc_name }}
    - cidr_block: {{ vpc_data.cidr_prefix }}.{{ subnet_data.subnet_number }}.0/24
    - availability_zone: {{ region_name }}{{ subnet_data.az }}
    - region: {{ region_name }}
    {% endfor %}

    {% if vpc_data.get('nat_gateway', false)%}
nat_gateway_{{ vpc_data.get('nat_gateway').get('subnet_name') }}_in_vpc_{{ vpc_name }}:
  boto_vpc.nat_gateway_present:
    - subnet_name: {{ vpc_data.get('nat_gateway').get('subnet_name') }}-{{ vpc_name }}
    - region: {{ region_name }}
    {% endif %}

    {% for table_name, table_data in vpc_data.get('routing_tables', {}).items() %}
route_table_{{ table_name }}_in_vpc_{{ vpc_name }}:
  boto_vpc.route_table_present:
    - name: {{ table_name }}-{{ vpc_name }}
    - vpc_name: {{ vpc_name }}
    - region: {{ region_name }}
      {% if table_data.get('routes', false) %}
    - routes:
        {% for route_name, route_data in table_data.get('routes').items() %}
          {% for key, value in route_data.items() %}
            {% if loop.first %}
      - {{ key }}: {{ value }}
            {% else %}
        {{ key }}: {{ value }}
            {% endif %}
          {% endfor %}
        {% endfor %}
      {% endif %}
      {% if table_data.get('subnet_names', false) %}
    - subnet_names:
        {% for subnet_name in table_data.subnet_names %}
      - {{ subnet_name }}-{{ vpc_name }}
        {% endfor %}
      {% endif %}
    {% endfor %}

request_peering_connection_for_salt_master_from_{{ vpc_name }}:
  boto_vpc.request_vpc_peering_connection:
    - requester_vpc_name: {{ vpc_name }}
    - peer_vpc_name: test-chamber
    - conn_name: {{ vpc_name }}-to-salt-master
    - region: {{ region_name }}

#accept_peering_request:
#  boto_vpc.accept_vpc_peering_connection:
#    - conn_name: {{ vpc_name }}-to-salt-master
#    - region: {{ region_name }}
  {% endfor %}
{% endfor %}
