FusionDirectory Docker Container
================================

A docker image for [Fusiondirectory](http://fusiondirectory.org).
It installs and configures nginx + php5-fpm 


ToDO
---------
fix the 777
php7 to external docker
fix ldap
change setup for auto setup

How to use
----------

This docker image *depends on an LDAP server* which contains the Fusiondirectory's LDAP schemas.
You can use [jrohde/fusiondirectory-ldap-docker](https://hub.docker.com/j/jrohde/fusiondirectory-ldap-docker)
which keeps the persistent data in a Docker volume at `/data`.

```
docker run -d --name ldap -e LDAP_DOMAIN=example.com -e LDAP_ROOTPW=secret jrohde/fusiondirectory-ldap-docker
```

Now you can run this container with a link to that LDAP server, named `ldap`:

```
docker run -d 8080:80 -e LDAP_DOMAIN=example.com -e LDAP_ROOTPW=secret -e LDAP_ROOTDN="cn=admin,dc=example,dc=com" --link ldap:ldap jrohde/fusiondirectory-docker
```

Now open http://localhost:12080 and login as `fd-admin` using `LDAP_ROOTPW` as password.

Connection variables
--------------------

These environment variables are used to connect to the LDAP server:

* `LDAP_HOST`: ldap server (default: `openldap`)
* `LDAP_PORT`: tcp port on ldap server (default: `389`)
* `LDAP_TLS`: protocol on ldap server (default: `false`)
* `LDAP_DOMAIN`: LDAP domain (default: `example.com`)
* `LDAP_ROOTDN`: ROOT DN of the ldap server (default: `cn=admin,<domain suffix, e.g. dc=example,dc=com`)
* `LDAP_ROOTPW`: ROOT password of the ROOT DN of the ldap server

These environment variables allow you to configure additional addons,plugins & themes:

* `FD_PLUGINS`: comma seperated list of plugins (current plugin options are: `argonaut,user-reminder,sympa,supann,squid,spamassassin,sogo,repository,puppet,ppolicy,personal,opsi,newsletter,netgroups,nagios,mixedgroups,kolab2,ipmi,fusioninventory,fai,ejbca,dsa,dovecot,dhcp,	developers,debconf,cyrus,community,audit,applications,alias,subcontracting,samba,dns,autofs,certificates,gpg,ldapdump,ldapmanager,mail,postfix,ssh,sudo,systems,weblink,webservice,freeradius,quota,pureftpd`. default: ``)
* `FD_WEBSERVICE_SHELL`: install the webservice shell (default: `false`)
* `FD_THEME_OXYGEN`: install the Oxygen theme (default: `false`)

Web Service Access
------------------

if you installed the webservice plugin you can use [FusionDirectory web service](http://documentation.fusiondirectory.org/en/documentation/plugin/webservice_plugin)
for programmatic access to the FusionDirectory functionality.


Github Repo
-----------

https://github.com/jrohde/fusiondirectory-docker
