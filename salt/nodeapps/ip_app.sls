# copies ip app from salt master to minion
ip app:
  file.recurse:
    - name: /home/ubuntu/ip_app
    - source: salt://nodeapps/files/ip_app

# runs the app indefinitely with forever
start ip app:
  cmd.run:
    - name: forever start app.js
    - cwd: /home/ubuntu/ip_app
    - require:
      - file: ip app
