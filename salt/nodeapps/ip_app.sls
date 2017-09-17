ip app:
  file.recurse:
    - name: /home/ubuntu/ip_app
    - source: salt://nodeapps/files/ip_app

start ip app:
  cmd.run:
    - name: forever start app.js
    - cwd: /home/ubuntu/ip_app
    - require:
      - file: ip app
