{% set region = 'us-west-2' %}
region: {{ region }}

{% set vpcs = ['dev', 'production'] %}
vpcs:
{% for vpc in vpcs %}
  {{ vpc }}:
    prefix: 10.{{ loop.index }}
    mask: 16
{% endfor %}

{% set subnets = ['subnet-a', 'subnet-b', 'subnet-c'] %}
subnets:
{% for subnet in subnets %}
  {{ subnet }}:
    prefix: {{ loop.index }}
    mask: 24
    {% if 'subnet-a' in subnet %}
    az: {{ region }}a
    {% endif %}
    {% if 'subnet-b' in subnet %}
    az: {{ region }}b
    {% endif %}
    {% if 'subnet-c' in subnet %}
    az: {{ region }}c
    {% endif %}
{% endfor %}
