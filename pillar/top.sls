# matches aws pillar to Salt master since only the minion on master is the one executing AWS states 
base:
  'local':
    - aws
