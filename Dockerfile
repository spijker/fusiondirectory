FROM hrektts/nginx:latest
MAINTAINER mps299792458@gmail.com

ENV FUSIONDIRECTORY_DEB_PKG_VERSION=1.0.9.3-1

RUN export DEBIAN_FRONTEND=noninteractive && \ 
    export LC_ALL=es_ES.UTF-8 && \ 
    export LANG=C && \ 
    export LANGUAGE=C && \ 
    apt-get update && \ 
    apt-get install -y --no-install-recommends gnupg && \ 
    gpg --keyserver keys.gnupg.net --recv-keys E184859262B4981F && \ 
    gpg -a --export E184859262B4981F | apt-key add - && \ 
    echo 'deb http://repos.fusiondirectory.org/debian-jessie jessie main' > /etc/apt/sources.list.d/fusiondirectory-jessie.list \ 
    && apt-get update \ 
    && apt-get install -y --no-install-recommends php-mdb2 \ 
    fusiondirectory=${FUSIONDIRECTORY_DEB_PKG_VERSION} \ 
    fusiondirectory-plugin-alias=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-apache2=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-applications=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-argonaut=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-autofs=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-cyrus=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-debconf=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-dhcp=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-dns=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-dovecot=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-dsa=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-ejbca=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-fai=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-freeradius=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-fusioninventory=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-gpg=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-ipmi=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-kolab2=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-mail=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-nagios=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-netgroups=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-opsi=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-personal=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-ppolicy=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-puppet=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-pureftpd=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-quota=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \
    fusiondirectory-plugin-repository=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-samba=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-sogo=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-squid=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-ssh=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-sudo=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-supann=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-sympa=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-systems=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-weblink=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-plugin-webservice=${FUSIONDIRECTORY_DEB_PKG_VERSION}* \ 
    fusiondirectory-webservice-shell=${FUSIONDIRECTORY_DEB_PKG_VERSION}* && \ 
    apt-get clean && rm -rf /var/lib/apt/lists/*
 

RUN export TARGET=/etc/php5/fpm/php.ini \
 && sed -i -e "s:^;\(opcache.enable\) *=.*$:\1=1:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.enable_cli\) *=.*$:\1=0:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.memory_consumption\) *=.*$:\1=1024:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.max_accelerated_files\) *=.*$:\1=65407:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.validate_timestamps\) *=.*$:\1=0:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.revalidate_path\) *=.*$:\1=1:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.error_log\) *=.*$:\1=/dev/null:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.log_verbosity_level\) *=.*$:\1=1:" ${TARGET} \
 && unset TARGET

RUN export TARGET=/etc/php5/fpm/pool.d/www.conf \
 && sed -i -e "s:^\(listen *= *\).*$:\1/run/php5-fpm.sock:" ${TARGET} \
 && unset TARGET

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
COPY cmd.sh /sbin/cmd.sh
RUN chmod 755 /sbin/cmd.sh
COPY default /etc/nginx/sites-available/

EXPOSE 80 443
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/sbin/cmd.sh"]
