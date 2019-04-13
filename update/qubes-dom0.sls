# Migrate to new onion repositories automatically, even if the user modified
# the repository file (in which case rpm do not automatically replace it)
/etc/yum.repos.d/qubes-dom0.repo:
  file.replace:
    - pattern: sik5nlgfc5qylnnsr57qrbm64zbdx6t4lreyhpon3ychmxmiem7tioad
    - repl: qubesosfasa4zl44o4tws22di6kepyzfeqv3tg4e3ztknltfxqrymdad

/etc/yum.repos.d/qubes-templates.repo:
  file.replace:
    - pattern: sik5nlgfc5qylnnsr57qrbm64zbdx6t4lreyhpon3ychmxmiem7tioad
    - repl: qubesosfasa4zl44o4tws22di6kepyzfeqv3tg4e3ztknltfxqrymdad

update:
  pkg.uptodate:
    - refresh: True
