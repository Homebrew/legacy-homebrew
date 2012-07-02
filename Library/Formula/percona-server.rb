require 'formula'

class PerconaServer < Formula
  homepage 'http://www.percona.com'
  url 'http://www.percona.com/redir/downloads/Percona-Server-5.5/Percona-Server-5.5.24-26.0/source/Percona-Server-5.5.24-rel26.0.tar.gz'
  version '5.5.24-26.0'
  sha1 '4a815b545263d008f7112b7e8b1170ae97e9cf3e'

  keg_only "This brew conflicts with 'mysql'. It's safe to `brew link` if you haven't installed 'mysql'"

  depends_on 'cmake' => :build
  depends_on 'readline'
  depends_on 'pidof'

  skip_clean :all # So "INSTALL PLUGIN" can work.

  fails_with :llvm do
    build 2334
    cause "https://github.com/mxcl/homebrew/issues/issue/144"
  end

  def options
    [
      ['--with-tests', "Build with unit tests."],
      ['--with-embedded', "Build the embedded server."],
      ['--with-libedit', "Compile with EditLine wrapper instead of readline"],
      ['--universal', "Make mysql a universal binary"],
      ['--enable-local-infile', "Build with local infile loading support"]
    ]
  end

  # The CMAKE patches are so that on Lion we do not detect a private
  # pthread_init function as linkable. Patch sourced from the MySQL formula.
  def patches
    DATA
  end

  def install
    # Make sure the var/msql directory exists
    (var+"percona").mkpath

    args = std_cmake_args + [
      ".",
      "-DMYSQL_DATADIR=#{var}/percona",
      "-DINSTALL_MANDIR=#{man}",
      "-DINSTALL_DOCDIR=#{doc}",
      "-DINSTALL_INFODIR=#{info}",
      # CMake prepends prefix, so use share.basename
      "-DINSTALL_MYSQLSHAREDIR=#{share.basename}",
      "-DWITH_SSL=yes",
      "-DDEFAULT_CHARSET=utf8",
      "-DDEFAULT_COLLATION=utf8_general_ci",
      "-DSYSCONFDIR=#{etc}",
      "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
      # PAM plugin is Linux-only at the moment
      "-DWITHOUT_AUTH_PAM=1",
      "-DWITHOUT_AUTH_PAM_COMPAT=1",
      "-DWITHOUT_DIALOG=1"
    ]

    # To enable unit testing at build, we need to download the unit testing suite
    if ARGV.include? '--with-tests'
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if ARGV.include? '--with-embedded'

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" unless ARGV.include? '--with-libedit'

    # Make universal for binding to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if ARGV.build_universal?

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if ARGV.include? '--enable-local-infile'

    system "cmake", *args
    system "make"
    system "make install"

    plist_path.write startup_plist

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'

    # Link the setup script into bin
    ln_s prefix+'scripts/mysql_install_db', bin+'mysql_install_db'
    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
    end
    ln_s "#{prefix}/support-files/mysql.server", bin
  end

  def caveats; <<-EOS.undent
    Set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix percona-server)" --datadir=#{var}/percona --tmpdir=/tmp

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

    To launch on startup:
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
diff --git a/configure.cmake b/configure.cmake
index c3cc787..6193481 100644
--- a/configure.cmake
+++ b/configure.cmake
@@ -149,7 +149,9 @@ IF(UNIX)
   SET(CMAKE_REQUIRED_LIBRARIES 
     ${LIBM} ${LIBNSL} ${LIBBIND} ${LIBCRYPT} ${LIBSOCKET} ${LIBDL} ${CMAKE_THREAD_LIBS_INIT} ${LIBRT})
 
-  LIST(REMOVE_DUPLICATES CMAKE_REQUIRED_LIBRARIES)
+  IF(CMAKE_REQUIRED_LIBRARIES)
+    LIST(REMOVE_DUPLICATES CMAKE_REQUIRED_LIBRARIES)
+  ENDIF()
   LINK_LIBRARIES(${CMAKE_THREAD_LIBS_INIT})
   
   OPTION(WITH_LIBWRAP "Compile with tcp wrappers support" OFF)
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index 9296075..a600de2 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -137,7 +137,8 @@ for remove in DDBUG_OFF DSAFE_MUTEX DUNIV_MUST_NOT_INLINE DFORCE_INIT_OF_VARS \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
diff --git a/scripts/mysqld_safe.sh b/scripts/mysqld_safe.sh
index 37e0e35..38ad6c8 100644
--- a/scripts/mysqld_safe.sh
+++ b/scripts/mysqld_safe.sh
@@ -558,7 +558,7 @@ else
 fi
 
 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
