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
