{% set aws_data = salt['pillar.get']('aws', {}) %}

{% for region_name, region_data in aws_data.get('region', {}).items() %}
  {% for vpc_name, vpc_data in region_data.get('vpc', {}).items() %}
    {% for sg_name, sg_data in vpc_data.get('security_groups', {}).items() %}
sg_{{ sg_name }}_in_vpc_{{ vpc_name }}:
  boto_secgroup.present:
    - name: {{ sg_name }}-{{ vpc_name }}
    - description: {{ sg_data.description }}
    - vpc_name: {{ vpc_name }}
      {% if sg_data.get('rules', false) %}
    - rules:
        {% for rule_name, rule_data in sg_data.get('rules').items() %}
        - ip_protocol: {{ rule_data.ip_protocol }}
          from_port: {{ rule_data.get('from_port', rule_data.get('port')) }}
          to_port: {{ rule_data.get('to_port', rule_data.get('port')) }}
          {% if rule_data.get('cidr_ip', false) %}
            {% if rule_data.get('cidr_ip') is not string %}
          cidr_ip:
              {% for ip in rule_data.cidr_ip %}
            - {{ id }}
              {% endfor %}
            {% else %}
          cidr_ip: {{ rule_data.cidr_ip }}
            {% endif %}
          {% endif %}
          {% if rule_data.get('source_group_name', false) %}
            {% if rule_data.get('source_group_name') is not string %}
          source_group_name:
              {% for sgn in rule_data.source_group_name %}
            - {{ sgn }}-{{ vpc_name }}
              {% endfor %}
            {% else %}
          source_group_name: {{ rule_data.source_group_name }}-{{ vpc_name }}
            {% endif %}
          {% endif %}
        {% endfor %}
      {% endif %}
      {% if sg_data.get('rules_egress', false) %}
    - rules_egress:
        {% for rule_name, rule_data in sg_data.get('rules_egress').items() %}
        - ip_protocol: {{ rule_data.ip_protocol }}
          from_port: {{ rule_data.get('from_port', rule_data.get('port')) }}
          to_port: {{ rule_data.get('to_port', rule_data.get('port')) }}
          {% if rule_data.get('cidr_ip', false) %}
            {% if rule_data.get('cidr_ip') is not string %}
          cidr_ip:
              {% for ip in rule_data.cidr_ip %}
            - {{ id }}
              {% endfor %}
            {% else %}
          cidr_ip: {{ rule_data.cidr_ip }}
            {% endif %}
          {% endif %}
          {% if rule_data.get('source_group_name', false) %}
            {% if rule_data.get('source_group_name') is not string %}
          source_group_name:
              {% for sgn in rule_data.source_group_name %}
            - {{ sgn }}-{{ vpc_name }}
              {% endfor %}
            {% else %}
          source_group_name: {{ rule_data.source_group_name }}-{{ vpc_name }}
            {% endif %}
          {% endif %}
        {% endfor %}
      {% endif %}
    - region: {{ region_name }}
    {% endfor %}
  {% endfor %}
{% endfor %}
