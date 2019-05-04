#!/bin/bash

LOCAL_DIR=$(pwd)
WEB_DIR=$(printf "%s/wordpress" ${LOCAL_DIR})

if [ -d "${WEB_DIR}" ]
then
	sudo rm -rf ${WEB_DIR}
fi

wget --progress=dot http://wordpress.org/latest.tar.gz 

tar xfz latest.tar.gz

rm -f latest.tar.*

cat <<'EOF' >> ${WEB_DIR}/wp-config.php
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', getenv('MYSQL_ENV_MYSQL_DATABASE') );

/** MySQL database username */
define( 'DB_USER', getenv('MYSQL_ENV_MYSQL_USER') );

/** MySQL database password */
define( 'DB_PASSWORD', getenv('MYSQL_ENV_MYSQL_PASSWORD') );

/** MySQL hostname */
define( 'DB_HOST', 'mysql' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
EOF

curl http://api.wordpress.org/secret-key/1.1/salt >> ${WEB_DIR}/wp-config.php


cat <<'EOF' >> ${WEB_DIR}/wp-config.php

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
EOF

docker build -t sioux .

sudo chmod 644 ${WEB_DIR}/wp-config.php
sudo chown -R www-data:www-data ${WEB_DIR}

docker run --name wordpress \
    -v ${WEB_DIR}:/var/www/html \
    -d \
    -P \
    -p 8080:80 \
    --link mysql:mysql \
    sioux
