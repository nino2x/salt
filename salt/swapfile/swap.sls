# make a swap file
Make and mount swapfile:
  cmd.run:
    - name: |
        dd if=/dev/zero of=/swapfile bs=1024 count=1024k
        chmod 0600 /swapfile
        mkswap /swapfile
        swapon /swapfile
  mount.swap:
    - name: /swapfile
    - persist: true
