nginx_installed:
  pkg.installed:
    - name: nginx

nginx_conf:
  file.managed:
    - name: /etc/nginx/conf.d/node-app.conf
    - source: salt://nginx/files/node-app.conf.jin
    - template: jinja
    - require:
      - pkg: nginx_installed

website_files:
  file.recurse:
    - name: /var/www/website
    - source: salt://nginx/files/static_website
    - clean: true

nginx_running:
  service.running:
    - name: nginx
    - enable: true
    - require:
      - pkg: nginx_installed
    - watch:
      - file: nginx_conf

nginx_restart:
  cmd.run:
    - name: systemctl restart nginx.service
#  module.watch:
#    - name: system.restart
#    - m_name: nginx
    - require:
       - file: nginx_conf
