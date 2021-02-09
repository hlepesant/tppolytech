#!/bin/bash

# curl -sSL http://wordpress.org/latest.tar.gz -o wordpress.tar.gz
curl -sSL https://fr.wordpress.org/latest-fr_FR.tar.gz -o wordpress.tar.gz
tar xfz wordpress.tar.gz

cat <<'EOF' >> wordpress/wp-config.php
<?php
define( 'DB_NAME', getenv('MYSQL_DATABASE') );
define( 'DB_USER', getenv('MYSQL_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );
define( 'DB_HOST', getenv('MYSQL_HOST') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
EOF

curl -fsSL http://api.wordpress.org/secret-key/1.1/salt >> wordpress/wp-config.php

cat <<'EOF' >> wordpress/wp-config.php

$table_prefix  = 'wp_';
define( 'WP_DEBUG', false );
if ( !defined('ABSPATH' ) )
  define( 'ABSPATH', dirname(__FILE__) . '/' );

require_once( ABSPATH . 'wp-settings.php');
EOF

chmod 0644 wordpress/wp-config.php
sudo mkdir -p wordpress/wp-content/{plugins,themes,upgrade,uploads}
sudo chown -R 33:33 wordpress/wp-content

rm -f wordpress.tar.gz
