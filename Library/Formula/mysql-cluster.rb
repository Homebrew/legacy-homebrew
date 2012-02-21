require 'formula'

class MysqlCluster < Formula
  homepage 'http://dev.mysql.com/doc/index-cluster.html'
  url 'http://dev.mysql.com/get/Downloads/MySQL-Cluster-7.2/mysql-cluster-gpl-7.2.4.tar.gz/from/http://mysql.mirrors.pair.com/'
  md5 '0c8cc7a38050dc36a78aaef4e32fd426'
  version '7.2.4'

  depends_on 'cmake' => :build
  depends_on 'readline'
  depends_on 'pidof'

  fails_with_llvm "https://github.com/mxcl/homebrew/issues/issue/144", :build => 2326

  skip_clean :all # So "INSTALL PLUGIN" can work.

  def options
    [
      ['--with-embedded-server', "Build the embedded server."],
      ['--with-libedit', "Compile with EditLine wrapper instead of readline"],
      ['--with-archive-storage-engine', "Compile with the ARCHIVE storage engine enabled"],
      ['--with-blackhole-storage-engine', "Compile with the BLACKHOLE storage engine enabled"],
      ['--universal', "Make mysql a universal binary"],
      ['--enable-local-infile', "Build with local infile loading support"]
    ]
  end

  def patches
    DATA
  end

  def install
    if Formula.factory("mysql").installed?
      raise <<-EOS.undent
        The 'mysql-cluster' formula conflicts with the 'mysql' formula.
        To install 'mysql-cluster' you will need to uninstall 'mysql'.
      EOS
    end
    # Make sure the var/mysql-cluster directory exists
    datadir=var+"mysql-cluster"
    if !datadir.directory?
      datadir.mkpath
    end

    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{datadir}",
            "-DINSTALL_MANDIR=#{man}",
            "-DINSTALL_DOCDIR=#{doc}",
            "-DINSTALL_INFODIR=#{info}",
            # CMake prepends prefix, so use share.basename
            "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/#{name}",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if ARGV.include? '--with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless ARGV.include? '--with-libedit'

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if ARGV.include? '--with-archive-storage-engine'

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if ARGV.include? '--with-blackhole-storage-engine'

    # Make universal for binding to universal applications
    if ARGV.build_universal?
      args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'"
    elsif MacOS.prefer_64_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES='x86_64'" if ARGV.build_universal?
    else
      args << "-DCMAKE_OSX_ARCHITECTURES='i386'" if ARGV.build_universal?
    end

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if ARGV.include? '--enable-local-infile'

    system "cmake", *args
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Fix up the control script and link into bin
    mysql_server_file = share+"mysql/mysql.server"
    inreplace mysql_server_file do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
    end
    ln_s mysql_server_file, bin+'mysql.server'
  end

  def caveats; <<-EOS.undent
    To migrate a MySQL setup created with the MySQL package installer:
      sudo launchctl unload /Library/LaunchDaemons/com.mysql.mysqld.plist
      sudo perl -p -i -e 's!/usr/local/mysql/!/usr/local/!g;' /Library/LaunchDaemons/com.mysql.mysqld.plist
      sudo chown _mysql:_mysql /usr/local/var/mysql-cluster
      sudo -u mysql mv /usr/local/mysql/var/* /usr/local/var/mysql-cluster
      sudo launchctl load -w /Library/LaunchDaemons/com.mysql.mysqld.plist

    To set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql-cluster)" --datadir=var+"mysql-cluster" --tmpdir=/tmp

    To set up base tables in another folder, or use a different user to run
    mysqld, view the help for mysqld_install_db:
        mysql_install_db --help

    and view the MySQL documentation:
      * http://dev.mysql.com/doc/refman/5.5/en/mysql-install-db.html
      * http://dev.mysql.com/doc/refman/5.5/en/default-privileges.html

    To run as, for instance, user "mysql", you may need to `sudo`:
        sudo mysql_install_db ...options...

    Start mysqld manually with:
        mysql.server start

        Note: if this fails, you probably forgot to run the first two steps up above

    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    To connect:
        mysql -uroot

    To launch on startup and run AS YOUR USER ACCOUNT:
    * if this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    * if this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    You may also need to edit the plist to use the correct "UserName".

    EOS
  end

  def startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{HOMEBREW_PREFIX}/bin/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOPLIST
  end
end


__END__
--- a/scripts/mysql_config.sh	2012-02-09 16:50:46.000000000 -0500
+++ b/scripts/mysql_config.sh	2012-02-09 16:51:31.000000000 -0500
@@ -134,7 +134,8 @@
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
diff -u -r a/scripts/mysqld_safe.sh b/scripts/mysqld_safe.sh
--- a/scripts/mysqld_safe.sh	2012-02-09 16:48:37.000000000 -0500
+++ b/scripts/mysqld_safe.sh	2012-02-09 16:50:27.000000000 -0500
@@ -384,7 +384,7 @@
 fi
 
 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
