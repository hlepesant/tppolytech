#!/bin/bash

cd /usr/share/nginx/

wget -q -O wordpress.tar.gz https://wordpress.org/wordpress-6.1.1.tar.gz
tar xfz wordpress.tar.gz -C /usr/share/nginx/

mv wordpress html

cat <<'EOF' >> html/wp-config.php
<?php
define( 'DB_NAME', getenv('MYSQL_DATABASE') );
define( 'DB_USER', getenv('MYSQL_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );
define( 'DB_HOST', getenv('MYSQL_HOST') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
EOF

wget -q -O - http://api.wordpress.org/secret-key/1.1/salt >> html/wp-config.php

cat <<'EOF' >> html/wp-config.php

define('WP_REDIS_HOST', getenv('REDIS_HOST') );
define('WP_REDIS_PORT', getenv('REDIS_PORT') );

$table_prefix  = 'wp_';
define( 'WP_DEBUG', false );
if ( !defined('ABSPATH' ) )
  define( 'ABSPATH', dirname(__FILE__) . '/' );

require_once( ABSPATH . 'wp-settings.php');
EOF

rm -f html/wp-config-sample.php
mkdir -p html/wp-content/plugins
mkdir -p html/wp-content/themes
mkdir -p html/wp-content/upgrade
mkdir -p html/wp-content/uploads
find html -type d -exec chmod 775 '{}' \;
find html -type f -exec chmod 664 '{}' \;
chmod 0644 html/wp-config.php
chown -R 101:101 html

rm -f wordpress.tar.gz
