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

# Migrate to new onion repositories automatically, even if the user modified
# the repository file (in which case rpm do not automatically replace it)
/etc/yum.repos.d/qubes-r4.repo:
  file.replace:
    - pattern: sik5nlgfc5qylnnsr57qrbm64zbdx6t4lreyhpon3ychmxmiem7tioad
    - repl: qubesosfasa4zl44o4tws22di6kepyzfeqv3tg4e3ztknltfxqrymdad
    - onlyif:
      - test -f /etc/yum.repos.d/qubes-r4.repo

/etc/apt/sources.list.d/qubes-r4.list:
  file.replace:
    - pattern: sik5nlgfc5qylnnsr57qrbm64zbdx6t4lreyhpon3ychmxmiem7tioad
    - repl: qubesosfasa4zl44o4tws22di6kepyzfeqv3tg4e3ztknltfxqrymdad
    - onlyif:
      - test -f /etc/apt/sources.list.d/qubes-r4.list

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

