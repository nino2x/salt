# deploy node-js-server ec2 instance from map
deploy_instances:
  salt.runner:
    - name: cloud.map_run
    - path: /srv/salt/cloudmaps/single_server.map

# create and mount a swapfile
make_swapfile:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - swapfile

# make sure nodejs, dependecies and apps are installed
deploy_node:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - nodeapps.app

# make sure nginx is installed and running
deploy_nginx:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - nginx

# run ip app
run_ip_app:
  salt.function:
    - name: cmd.run
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - kwarg:
        cmd: 'forever start app.js'
        cwd: '/home/ubuntu/ip_app'

# run Node-RED app
run_nodered_app:
  salt.function:
    - name: cmd.run_bg
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - kwarg:
        cmd: 'npm start'
        cwd: '/home/ubuntu/node-red'

#run_node:
#  salt.state:
#    - tgt: 'roles:webserver'
#    - tgt_type: grain
#    - sls:
#      - nodeapps.run

# run the beacon
deploy_beacon:
  salt.state:
    - tgt: 'roles:webserver'
    - tgt_type: grain
    - sls:
      - beacons.monitor_destroy_access

# deploys a load balancer
deploy_elb:
  salt.state:
    - tgt: 'local'
    - sls:
      - elb.elb

# assigns instances to elb
assign_instances:
  salt.state:
    - tgt: 'local'
    - sls:
      - elb.instances
