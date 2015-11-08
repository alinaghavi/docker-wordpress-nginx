#!/bin/bash
if [ ! -f /usr/share/nginx/www/wp-config.php ]; then
    #mysql has to be started this way as it doesn't work to call from /etc/init.d
    /usr/bin/mysqld_safe &
    sleep 10s

    # Unzip Wordpress in www
    cd /usr/share/nginx/ && unzip -o /usr/src/wp.zip
    mv /usr/share/nginx/html/5* /usr/share/nginx/www/wordpress
    mv /usr/share/nginx/wordpress/* /usr/share/nginx/www/
    rm -rf /usr/share/nginx/wordpress
    chown -R www-data:www-data /usr/share/nginx/www

    # Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
    WORDPRESS_DB="wordpress"
    MYSQL_PASSWORD=`pwgen -c -n -1 12`
    WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
    #This is so the passwords show up in logs.
    echo mysql root password: $MYSQL_PASSWORD
    echo wordpress password: $WORDPRESS_PASSWORD
    echo $MYSQL_PASSWORD > /mysql-root-pw.txt
    echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt

    sed -e "s/database_name_here/$WORDPRESS_DB/
    s/username_here/$WORDPRESS_DB/
    s/password_here/$WORDPRESS_PASSWORD/
    /'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
    /'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /usr/share/nginx/www/wp-config-sample.php > /usr/share/nginx/www/wp-config.php

    # Copy Avada theme files
    cd /usr/share/nginx/www/wp-content/themes && unzip -o /usr/src/Avada.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/themes/Avada

    # Installing Plugins
    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/nginx-helper.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/nginx-helper

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/wordfence.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/wordfence

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/wordpress-seo.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/wordpress-seo

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/google-captcha.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/google-captcha

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/google-analytics-for-wordpress.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/google-analytics-for-wordpress

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/duplicate-post.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/duplicate-post

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/user-role-editor.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/user-role-editor

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/adminimize.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/adminimize

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/loco-translate.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/loco-translate

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/stops-core-theme-and-plugin-updates.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/stops-core-theme-and-plugin-updates

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/wp-smushit.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/wp-smushit

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/all-in-one-wp-security-and-firewall.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/all-in-one-wp-security-and-firewall

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/underconstruction.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/underconstruction

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/w3-total-cache.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/w3-total-cache

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/contact-form-7.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/contact-form-7

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/legacy-admin.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/legacy-admin

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/LayerSlider.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/LayerSlider

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/fusion-core.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/fusion-core

    cd /usr/share/nginx/www/wp-content/plugins && unzip -o /usr/src/revslider.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/revslider

    # Remove unused plugins
    rm -rf /usr/share/nginx/www/wp-content/plugins/akismet
    rm /usr/share/nginx/www/wp-content/plugins/hello.php

    # Remove unused theme
    rm -rf /usr/share/nginx/www/wp-content/themes/twentyfifteen
    rm -rf /usr/share/nginx/www/wp-content/themes/twentyfourteen
    rm -rf /usr/share/nginx/www/wp-content/themes/twentythirteen

    # Add css file for customizing admin panel(for all users)
    mv /usr/src/admin_panel_base.css /usr/share/nginx/www/wp-content/themes/Avada
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/themes/Avada/admin_panel_base.css

    # Add css file for customizing admin panel(for admin-user role)
    mv /usr/src/admin_panel_user.css /usr/share/nginx/www/wp-content/themes/Avada
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/themes/Avada/admin_panel_user.css

    # Add font files
    cd /usr/share/nginx/www/wp-content/themes/Avada && unzip -o /usr/src/fonts.zip
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/themes/Avada/fonts

    # New 404.php file
    rm /usr/share/nginx/www/wp-content/themes/Avada/404.php
    mv /usr/src/404.php /usr/share/nginx/www/wp-content/themes/Avada
    chown -R www-data:www-data /usr/share/nginx/www/wp-content/themes/Avada/404.php

  # Activate nginx plugin once logged in
  cat << ENDL >> /usr/share/nginx/www/wp-config.php
\$plugins = get_option( 'active_plugins' );
if ( count( \$plugins ) === 0 ) {
  require_once(ABSPATH .'/wp-admin/includes/plugin.php');
  \$pluginsToActivate = array( 'nginx-helper/nginx-helper.php', 'duplicate-post/duplicate-post.php', 'user-role-editor/user-role-editor.php', 'adminimize/adminimize.php', 'stops-core-theme-and-plugin-updates/main.php', 'wp-smushit/wp-smush.php', 'all-in-one-wp-security-and-firewall/wp-security.php', 'underconstruction/underConstruction.php', 'contact-form-7/wp-contact-form-7.php', 'legacy-admin/legacy-core.php', 'wp-jalali/wp-jalali.php');
  foreach ( \$pluginsToActivate as \$plugin ) {
    if ( !in_array( \$plugin, \$plugins ) ) {
      activate_plugin( '/usr/share/nginx/www/wp-content/plugins/' . \$plugin );
    }
  }
}
ENDL
chown www-data:www-data /usr/share/nginx/www/wp-config.php

# Edit function.php
cat << ENDL >> /usr/share/nginx/www/wp-content/themes/Avada/functions.php
\$mylocale = get_bloginfo('language');
if(\$mylocale == 'fa-IR')
{
add_filter('date_i18n', 'ztjalali_ch_date_i18n', 111, 4);
}

function my_admin_theme_style_base() {
wp_register_style( 'custom_wp_admin_css_base', get_template_directory_uri() . '/admin_panel_base.css', false, '1.0.0' );
wp_enqueue_style( 'custom_wp_admin_css_base' );
}
add_action( 'admin_enqueue_scripts', 'my_admin_theme_style_base' );


add_action('admin_head', 'my_custom_fonts');

function my_custom_fonts() { ?>
<style>
	<?php

        function get_user_role1() {
            global \$current_user;
            \$user_roles = \$current_user->roles;
            \$user_role = array_shift($user_roles);
            echo "salam";
            return \$user_role;

        }

        if ( get_user_role1() == "site-admin" )
        {
            echo file_get_contents(get_template_directory_uri() . '/admin_panel_user.css');
            echo "salam";
        }
    ?>

</style>
<?php }
ENDL
    chown www-data:www-data /usr/share/nginx/www/themes/Avada/admin_panel_user.css
    chown www-data:www-data /usr/share/nginx/www/themes/Avada/admin_panel_base.css

    rm -rf /usr/src/*

    mysqladmin -u root password $MYSQL_PASSWORD
    mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
    mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
    killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n
