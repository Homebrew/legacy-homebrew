require 'formula'

class Mysql < Formula
  homepage 'http://dev.mysql.com/doc/refman/5.5/en/'
  url 'http://ftp.sunet.se/pub/unix/databases/relational/mysql/Downloads/MySQL-5.5/mysql-5.5.10.tar.gz'
  md5 'ee604aff531ff85abeb10cf332c1355a'

  depends_on 'cmake' => :build
  depends_on 'readline'

  fails_with_llvm "https://github.com/mxcl/homebrew/issues/issue/144"

  def options
    [
      ['--with-tests', "Build with unit tests."],
      ['--with-embedded', "Build the embedded server."],
      ['--universal', "Make mysql a universal binary"],
      ['--enable-local-infile', "Build with local infile loading support"]
    ]
  end

  def patches; DATA; end

  def install
    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{var}/mysql",
            "-DINSTALL_MANDIR=#{man}",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # To enable unit testing at build, we need to download the unit testing suite
    args << "-DWITH_UNIT_TESTS=OFF" if not ARGV.include? '--with-tests'
    args << "-DENABLE_DOWNLOADS=ON" if ARGV.include? '--with-tests'

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if ARGV.include? '--with-embedded'

    # Make universal for bindings to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='ppc;i386'" if ARGV.include? '--universal'

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if ARGV.include? '--enable-local-infile'

    system "cmake", *args
    system "make"
    system "make install"

    (prefix+'com.mysql.mysqld.plist').write startup_plist

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+'data'
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        cd #{prefix}
        scripts/mysql_install_db --basedir=#{prefix} --user=mysql --tmpdir=/tmp

    Running the mysql_install_db command with the user and tmpdir option will
        ensure that there is no issue creating your system databases.

    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

    If this is an upgrade and you already have the com.mysql.mysqld.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/com.mysql.mysqld.plist
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

    Note on upgrading:
        We overwrite any existing com.mysql.mysqld.plist in ~/Library/LaunchAgents
        if we are upgrading because previous versions of this brew created the
        plist with a version specific program argument.

    Or start manually with:
        mysqld_safe &
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
      <string>com.mysql.mysqld</string>
      <key>Program</key>
      <string>#{bin}/mysqld_safe</string>
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
--- old/scripts/mysqld_safe.sh  2009-09-02 04:10:39.000000000 -0400
+++ new/scripts/mysqld_safe.sh  2009-09-02 04:52:55.000000000 -0400
@@ -383,7 +383,7 @@
 fi

 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
diff --git a/scripts/mysql_config.sh b/scripts/mysql_config.sh
index efc8254..8964b70 100644
--- a/scripts/mysql_config.sh
+++ b/scripts/mysql_config.sh
@@ -132,7 +132,8 @@ for remove in DDBUG_OFF DSAFEMALLOC USAFEMALLOC DSAFE_MUTEX \
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
