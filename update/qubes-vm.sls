{% if grains['os_family'] == 'RedHat' %}
{% if grains['os'] == 'Fedora' and grains['osmajorrelease'] < 33 %}
/usr/lib/rpm/macros.d/macros.qubes:
  file.managed:
    - contents: |
        # CVE-2021-20271 mitigation
        %_pkgverify_level all
{% else %}
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
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
dnf-makecache:
  cmd.script:
    - source: salt://update/dnf-makecache
    - runas: root
    - stateful: True
{% endif %}

{% if grains['oscodename'] == 'buster' %}
# https://bugs.debian.org/931566
# Apply the workaround manually, to be able to pull in the fixed apt version
apt-get update --allow-releaseinfo-change:
  cmd.run:
   - order: 1
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
