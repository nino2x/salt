# install pip
install_pip:
  pkg.installed:
    - name: python-pip

# install pyinotify
install_pyinotify:
  pip.installed:
    - name: pyinotify
    - require:
      - pkg: install_pip

# copy beacon to minion
beacon_file:
  file.managed:
    - name: /etc/salt/minion.d/monitor_destroy_access.conf
    - source: salt://beacons/monitor_destroy_access/files/monitor_destroy_access.conf

# restart salt minion service
#restart_minion:
#  module.wait:
#    - name: systemd.restart
#    - m_name: salt-minion
restart_minion:
  cmd.run:
    - name: 'salt-call --local service.restart salt-minion'
    - bg: true
