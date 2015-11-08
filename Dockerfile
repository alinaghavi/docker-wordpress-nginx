FROM ubuntu:14.04
MAINTAINER Ali Naghavi <naghavi.ali@gmail.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install mysql-server mysql-client nginx php5-fpm php5-mysql php-apc pwgen python-setuptools curl git unzip

# Wordpress Requirements
RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# Download Wordpress
# RUN curl -v -L -o /usr/src/latest-fa_IR.zip -O http://fa.wordpress.org/latest-fa_IR.zip
  ADD ./files/wp.zip /usr/src/

# Add Avada theme
  ADD ./files/Avada.zip /usr/src/

# Download plugins
  RUN curl -o /usr/src/nginx-helper.zip -O `curl -i -s https://wordpress.org/plugins/nginx-helper/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/wordfence.zip -O `curl -i -s https://wordpress.org/plugins/wordfence/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/wordpress-seo.zip -O `curl -i -s https://wordpress.org/plugins/wordpress-seo/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/google-captcha.zip -O `curl -i -s https://wordpress.org/plugins/google-captcha/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/google-analytics-for-wordpress.zip -O `curl -i -s https://wordpress.org/plugins/google-analytics-for-wordpress/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/duplicate-post.zip -O `curl -i -s https://wordpress.org/plugins/duplicate-post/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/user-role-editor.zip -O `curl -i -s https://wordpress.org/plugins/user-role-editor/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/adminimize.zip -O `curl -i -s https://wordpress.org/plugins/adminimize/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/loco-translate.zip -O `curl -i -s https://wordpress.org/plugins/loco-translate/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/stops-core-theme-and-plugin-updates.zip -O `curl -i -s https://wordpress.org/plugins/stops-core-theme-and-plugin-updates/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/wp-smushit.zip -O `curl -i -s https://wordpress.org/plugins/wp-smushit/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/all-in-one-wp-security-and-firewall.zip -O `curl -i -s https://wordpress.org/plugins/all-in-one-wp-security-and-firewall/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/underconstruction.zip -O `curl -i -s https://wordpress.org/plugins/underconstruction/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/w3-total-cache.zip -O `curl -i -s https://wordpress.org/plugins/w3-total-cache/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  RUN curl -o /usr/src/contact-form-7.zip -O `curl -i -s https://wordpress.org/plugins/contact-form-7/ | egrep -o "https://downloads.wordpress.org/plugin/[^']+"`

  ADD ./files/legacy-admin.zip /usr/src/

  ADD ./files/LayerSlider.zip /usr/src/

  ADD ./files/fusion-core.zip /usr/src/

  ADD ./files/revslider.zip /usr/src/

  ADD ./files/fonts.zip /usr/src/

# Add css file for customizing admin panel(for all users)
  ADD ./files/admin_panel_base.css /usr/src/

# Add css file for customizing admin panel(for admin-user role)
  ADD ./files/admin_panel_user.css /usr/src/

# Remove 404 php file and add new 404.php file
  ADD ./files/404.php /usr/src/

# Wordpress Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

# Install SSH
RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:Sana11811' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# private expose
EXPOSE 80 22 3306

# volume for mysql database and wordpress install
VOLUME ["/usr/share/nginx/www"]

CMD ["/bin/bash", "/start.sh"]
