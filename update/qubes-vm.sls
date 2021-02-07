{% if grains['os_family'] == 'RedHat' %}
dnf-makecache:
  cmd.script:
    - source: salt://update/dnf-makecache
    - runas: root
    - stateful: True
{% endif %}

update:
  pkg.uptodate:
    - refresh: True
{% if grains['os'] == 'Debian' %}
    - dist_upgrade: True
{% elif grains['os_family'] == 'RedHat' %}
    - require:
      - cmd: dnf-makecache
{% endif %}

notify-updates:
  cmd.run:
    - name: /usr/lib/qubes/upgrades-status-notify
