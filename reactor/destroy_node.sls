# write to log
log_write:
  local.file.append:
    - tgt: 'local'
    - arg:
      - /home/ubuntu/destroy.log
      - 'Server is destroyed'

# delete node server
#cloud_delete_minion:
#  runner.cloud.destroy:
#    - instances: node-js-server
