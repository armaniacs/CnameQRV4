CnameQRV4
=============

It is control panel for cdn.debian.net.
http://www.slideshare.net/ar_maniacs/araki-gemdebian2013b

Components of cdn.debian.net
===============================

1. CnameQRV4 (Control plane): It is included in this package. Run as a Rails Application on httpd.
1. HTTP checker for surrogate.
1. DNS (derived from DNSbalance. It is **NOT included** in this package. See https://github.com/armaniacs/cdn-dns )

Components of CnameQRV4
-------------------------

CnameQRV depends many of libraries.

* Rails4.0
* aws-sdk
* dalli (memcached library for ruby)

Run
-----------------

CnameQRV4 is running as an application of rails.

Cron run for periodic check
------------------------------

Set following configuration by crontab -e.

    */10 * * * * /usr/bin/curl localhost/check/check20 >/dev/null

`/check/check20` picks 20 hosts. It delegates healthcheck of mirror servers through SQS.




