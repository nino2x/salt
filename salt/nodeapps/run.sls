# start ip app
Start ip app:
  cmd.run:
    - name: forever start app.js
    - cwd: /home/ubuntu/ip_app

# start Node-RED
Start Node-RED:
  cmd.run:
    - name: npm start
    - cwd: /home/ubuntu/node-red
    - bg: true
