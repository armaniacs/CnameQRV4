Scripts for cdn.debian.net
============================

checkq-receive-forward.rb
----------------------------

It is run by daemontools.

/etc/service/checkq-receive-forward.rb/run

    etc/service/checkq-receive-forward.rb# more run
    #!/bin/sh
    exec bash -c 'ruby /root/CnameQRV4/script/checkq-receive-forward.rb'

    