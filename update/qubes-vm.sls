{% if grains['os'] == 'Debian' %}
# mitigation for DSA-4371-1 (CVE-2019-3462)
dsa-4371-update:
  cmd.script:
    - source: salt://update/dsa-4371-update
    - runas: root
    - stateful: True
{% endif %}

{% if grains['oscodename'] == 'stretch' %}
# remove jessie-backports erroneously added to stretch template
/etc/apt/sources.list:
  file.line:
    - mode: delete
    - content: "https://deb.debian.org/debian jessie-backports main"
    - onlyif:
      - test -f /etc/apt/sources.list
{% endif %}

{% if grains['os'] == 'Fedora' %}
# workaround for https://bugzilla.redhat.com/1669247
dnf list updates --refresh >/dev/null:
  cmd.run
{% endif %}

update:
  pkg.uptodate:
    - refresh: True
{% if grains['os'] == 'Debian' %}
    - dist_upgrade: True
    - require:
      - cmd: dsa-4371-update
{% endif %}

