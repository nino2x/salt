run highstate:
  local.state.highstate:
    - tgt: {{ data['name'] }}
