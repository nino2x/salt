# /srv/salt/nodeapps/app.sls

# install node, npm and git
Install prerequisites:
  pkg.installed:
    - pkgs:
      - npm
      - nodejs-legacy
      - git

# install forever
install forever:
  npm.installed:
    - name: forever
    - require:
      - pkg: Install prerequisites

# clone Node-RED
Git clone Node-RED:
  cmd.run:
    - name: git clone https://github.com/node-red/node-red.git
    - cwd: /home/ubuntu
    - require:
      - pkg: Install prerequisites

# copy ip app
Copy ip app:
  file.recurse:
    - name: /home/ubuntu/ip_app
    - source: salt://nodeapps/files/ip_app

# npm install Node-RED:
Install Node-RED:
  cmd.run:
    - name: npm install
    - cwd: /home/ubuntu/node-red
    - require:
      - cmd: Git clone Node-RED

# build Node-RED
Build Node-RED:
  cmd.run:
    - name: npm run build
    - cwd: /home/ubuntu/node-red
    - require:
      - cmd: Install Node-RED

# copy openmct app
#openmct app:
#  file.recurse:
#    - name: /home/ubuntu/openmct
#    - source: salt://nodeapps/files/openmct

# start ip app
#Start ip app:
#  cmd.run:
#    - name: forever start app.js
#    - cwd: /home/ubuntu/ip_app
#    - require:
#      - file: Copy ip app

# start Node-RED
#Start Node-RED:
#  cmd.run:
#    - name: npm start
#    - cwd: /home/ubuntu/node-red
#    - bg: true
#    - require:
#      - cmd: Build Node-RED

# start openmct app
#start openmct app:
#  cmd.run:
#    - name: forever start app.js
#    - cwd: /home/ubuntu/openmct
#    - require:
#      - file: openmct app
