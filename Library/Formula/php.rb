require 'formula'

def mysql_installed?
  `which mysql_config`.length > 0
end

class Php <Formula
  url 'http://www.php.net/get/php-5.3.9.tar.gz/from/this/mirror'
  homepage 'http://php.net/'
  md5 'c79e374c61423beb64a69da1eb5526b7'
  version '5.3.9'

  # So PHP extensions don't report missing symbols
  skip_clean ['bin', 'sbin']

  depends_on 'libxml2'
  depends_on 'jpeg'
  depends_on 'mcrypt'
  depends_on 'gettext'
  if ARGV.include? '--with-mysql'
    depends_on 'mysql' unless mysql_installed?
  end
  if ARGV.include? '--with-fpm'
    depends_on 'libevent'
  end
  if ARGV.include? '--with-pgsql'
    depends_on 'postgresql'
  end
  if ARGV.include? '--with-mssql'
    depends_on 'freetds'
  end
  if ARGV.include? '--with-intl'
    depends_on 'icu4c'
  end
  if ARGV.include? '--with-readline'
    depends_on 'readline'
  end
  
  def options
   [
     ['--with-mysql', 'Include MySQL support'],
     ['--with-pgsql', 'Include PostgreSQL support'],
     ['--with-mssql', 'Include MSSQL-DB support'],
     ['--with-fpm', 'Enable building of the fpm SAPI executable'],
     ['--with-apache', 'Build shared Apache 2.0 Handler module'],
     ['--with-intl', 'Include intl extension'],
     ['--with-readline', 'Include readline extension']
   ]
  end

  def patches
   DATA
  end
  
  def configure_args
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-config-file-path=#{prefix}/etc",
      "--with-iconv-dir=/usr",
      "--enable-exif",
      "--enable-soap",
      "--enable-sqlite-utf8",
      "--enable-wddx",
      "--enable-ftp",
      "--enable-sockets",
      "--enable-zip",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-sysvmsg",
      "--enable-memory-limit",
      "--enable-mbstring",
      "--enable-mbregex",
      "--enable-bcmath",
      "--enable-calendar",
      "--enable-memcache",
      "--enable-zend-multibyte",
      "--with-openssl=/usr",
      "--with-zlib=/usr",
      "--with-bz2=/usr",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-iodbc",
      "--with-kerberos=/usr",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      "--with-xsl=/usr",
      "--with-curl=/usr",
      "--with-gd",
      "--with-snmp=/usr",
      "--enable-gd-native-ttf",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-png-dir=/usr/X11",
      "--with-freetype-dir=/usr/X11",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-tidy",
      "--mandir=#{man}"
    ]

    # Bail if both php-fpm and apxs are enabled
    # http://bugs.php.net/bug.php?id=52419
    if (ARGV.include? '--with-fpm') && (ARGV.include? '--with-apache')
      onoe "You can only enable PHP FPM or Apache, not both"
      puts "http://bugs.php.net/bug.php?id=52419"
      exit 99
    end

    # Enable PHP FPM
    if ARGV.include? '--with-fpm'
      args.push "--enable-fpm"
    end

    # Build Apache module
    if ARGV.include? '--with-apache'
      args.push "--with-apxs2=/usr/sbin/apxs"
      args.push "--libexecdir=#{prefix}/libexec"
    end

    if ARGV.include? '--with-mysql'
      args.push "--with-mysql-sock=/tmp/mysql.sock"
      args.push "--with-mysqli=mysqlnd"
      args.push "--with-mysql=mysqlnd"
      args.push "--with-pdo-mysql=mysqlnd"
    end

    if ARGV.include? '--with-pgsql'
      args.push "--with-pgsql=#{Formula.factory('postgresql').prefix}"
      args.push "--with-pdo-pgsql=#{Formula.factory('postgresql').prefix}"
    end

    if ARGV.include? '--with-mssql'
      args.push "--with-mssql=#{Formula.factory('freetds').prefix}"
    end

    if ARGV.include? '--with-intl'
      args.push "--enable-intl"
      args.push "--with-icu-dir=#{Formula.factory('icu4c').prefix}"
    end
    
    if ARGV.include? '--with-readline'
      args.push "--with-readline=#{Formula.factory('readline').prefix}"
    end

    return args
  end
  
  def install
    # Because for icu4c, we must link with c++ when building with intl extension
    ENV.append 'LDFLAGS', '-lstdc++' if ARGV.include? '--with-intl'

    ENV.x11 # For freetype and libpng
    ENV.O3 # Speed things up
    system "./configure", *configure_args

    if ARGV.include? '--with-apache'
      # Use Homebrew prefix for the Apache libexec folder
      inreplace "Makefile",
        "INSTALL_IT = $(mkinstalldirs) '$(INSTALL_ROOT)/usr/libexec/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='$(INSTALL_ROOT)/usr/libexec/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so",
        "INSTALL_IT = $(mkinstalldirs) '#{prefix}/libexec/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='#{prefix}/libexec/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so"
    end
    
    system "make"
    system "make install"

    system "cp ./php.ini-production #{prefix}/etc/php.ini"

    # Fix pear permissions
    system "chmod 644 #{prefix}/lib/php/.lock"

    if ARGV.include? '--with-fpm'
      (prefix+'org.php.php-fpm.plist').write startup_plist
      system "cp #{prefix}/etc/php-fpm.conf.default #{prefix}/etc/php-fpm.conf"
      (prefix+'var/log').mkpath
      touch prefix+'var/log/php-fpm.log'
    end
  end

 def caveats; <<-EOS
   To enable PHP in Apache add the following to httpd.conf and restart Apache:
    LoadModule php5_module    #{prefix}/libexec/apache2/libphp5.so

    The php.ini file can be found in:
      #{prefix}/etc/php.ini
   EOS
 end


 def startup_plist; <<-EOPLIST.undent
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     <key>Label</key>
     <string>org.php.php-fpm</string>
     <key>Program</key>
     <string>#{sbin}/php-fpm</string>
     <key>RunAtLoad</key>
     <true/>
   </dict>
   </plist>
   EOPLIST
 end
end

__END__
diff -Naur php-5.3.2/ext/tidy/tidy.c php/ext/tidy/tidy.c 
--- php-5.3.2/ext/tidy/tidy.c	2010-02-12 04:36:40.000000000 +1100
+++ php/ext/tidy/tidy.c	2010-05-23 19:49:47.000000000 +1000
@@ -22,6 +22,8 @@
 #include "config.h"
 #endif
 
+#include "tidy.h"
+
 #include "php.h"
 #include "php_tidy.h"
 
@@ -31,7 +33,6 @@
 #include "ext/standard/info.h"
 #include "safe_mode.h"
 
-#include "tidy.h"
 #include "buffio.h"
 
 /* compatibility with older versions of libtidy */
