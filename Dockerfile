FROM nginx:latest

ENV FD_VERSION 1.0.19-1
ENV FD_PLUGINS argonaut,user-reminder,sympa,supann,squid,spamassassin,sogo,repository,puppet,ppolicy,personal,\
opsi,newsletter,netgroups,nagios,mixedgroups,kolab2,ipmi,fusioninventory,fai,ejbca,dsa,dovecot,dhcp,\
developers,debconf,cyrus,community,audit,applications,alias,subcontracting,samba,dns,autofs,certificates,\
gpg,ldapdump,ldapmanager,mail,postfix,ssh,sudo,systems,weblink,webservice,freeradius,quota,pureftpd
ENV FD_WEBSERVICE_SHELL true
ENV FD_THEME_OXYGEN true

RUN rm -f /etc/apt/sources.list.d/*
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys E184859262B4981F
RUN echo "deb http://repos.fusiondirectory.org/debian-jessie jessie main" > /etc/apt/sources.list.d/fusiondirectory-jessie.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y fusiondirectory=${FD_VERSION} php5-fpm php-mdb2

RUN tmp=""; for i in $(echo $FD_PLUGINS | sed "s/,/ /g"); do tmp="$tmp fusiondirectory-plugin-$i=${FD_VERSION}"; done; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y $tmp;

RUN if [ "$FD_WEBSERVICE_SHELL" = true ]; then \
		DEBIAN_FRONTEND=noninteractive apt-get install -y fusiondirectory-webservice-shell=${FD_VERSION}; \
	fi

RUN if [ "$FD_THEME_OXYGEN" = true ]; then \
		DEBIAN_FRONTEND=noninteractive apt-get install -y fusiondirectory-theme-oxygen=${FD_VERSION}; \
	fi

RUN rm -rf /var/lib/apt/lists/*

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
COPY fushiondirectory.nginx /etc/nginx/sites-available/fushiondirectory
RUN cd /etc/nginx/sites-enabled/ && rm default && ln -s ../sites-available/fushiondirectory 

EXPOSE 80 443
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/sbin/cmd.sh"]
