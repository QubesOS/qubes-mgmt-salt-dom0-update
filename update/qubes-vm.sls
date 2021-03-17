{% if grains['os_family'] == 'RedHat' %}
/usr/lib/rpm/macros.d/macros.qubes:
  file.managed:
    - contents: |
        # CVE-2021-20271 mitigation
        %_pkgverify_level all
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
