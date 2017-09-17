Open MCT app:
  file.recurse:
    - name: /home/ubuntu/openmct
    - source: salt://nodeapps/files/openmct

start nodered:
  cmd.run:
    - name: forever start app.js
    - cwd: /home/ubuntu/openmct
    - require:
      - file: Open MCT app
