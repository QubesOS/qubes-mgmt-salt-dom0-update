{% if grains['os_family'] == 'RedHat' %}
dnf-and-rpm:
  pkg.installed:
    - pkgs:
      - dnf: '>= 4.7.0'
      - rpm: '>= 4.14.2'

/usr/lib/rpm/macros.d/macros.qubes:
  file.absent:
    - require:
      - pkg: dnf-and-rpm
{% endif %}

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
      - file: /usr/lib/rpm/macros.d/macros.qubes
{% endif %}

notify-updates:
  cmd.run:
    - name: /usr/lib/qubes/upgrades-status-notify
