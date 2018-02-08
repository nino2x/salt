# runs ip app indefinitely with forever
Start ip app:
  cmd.run:
    - name: forever start app.js
    - cwd: /home/ubuntu/ip_app

# runs Node-RED with npm
# 'bg: true' allows the config to finish executing
# otherwise it waits for npm command to finish executing which it never does
Start Node-RED:
  cmd.run:
    - name: npm start
    - cwd: /home/ubuntu/node-red
    - bg: true
