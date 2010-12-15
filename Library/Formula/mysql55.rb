require 'formula'

class Mysql55 <Formula
  homepage 'http://dev.mysql.com/doc/refman/5.5/en/'
  url 'http://mysql.mirrors.pair.com/Downloads/MySQL-5.5/mysql-5.5.8.tar.gz'
  md5 '42e866302b61f5e213afd33e04677017'

  depends_on 'readline'
  depends_on 'cmake' => :build

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--universal', "Make mysql a universal binary"]
    ]
  end

  def patches
    DATA
  end

  def install
    fails_with_llvm "https://github.com/mxcl/homebrew/issues/issue/144"

    args = [
      ".",
      "-DCMAKE_INSTALL_PREFIX='#{prefix}'",
      "-DMYSQL_DATADIR='#{var}/mysql/data'",
      "-DINSTALL_MANDIR='#{man}'",
      "-DWITH_SSL=yes",
      "-DDEFAULT_CHARSET='utf8'",
      "-DDEFAULT_COLLATION='utf8_general_ci'",
      "-DSYSCONFDIR='#{HOMEBREW_PREFIX}/etc'"]

    args << "-DWITH_UNIT_TESTS=OFF" if not ARGV.include? '--with-tests'
    args << "-DINSTALL_SQLBENCHDIR=" if not ARGV.include? '--with-bench'
    
    # Make universal for bindings to universal applications
    args << "-DCMAKE_OSX_ARCHITECTURES='ppc;i386'" if ARGV.include? '--universal'

    system "cmake", *args

    system "make"

    system "make install"

    (prefix+'com.mysql.mysqld.plist').write startup_plist
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        cd #{prefix}
        scripts/mysql_install_db --basedir=#{prefix}

    If this is your first install, automatically load on login with:
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents
        launchctl load -w ~/Library/LaunchAgents/com.mysql.mysqld.plist

    If this is an upgrade and you already have the com.mysql.mysqld.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/com.mysql.mysqld.plist
        cp #{prefix}/com.mysql.mysqld.plist ~/Library/LaunchAgents
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
--- old/scripts/mysqld_safe.sh  2010-11-02 15:01:13.000000000 -0700
+++ new/scripts/mysqld_safe.sh  2010-12-14 12:34:31.000000000 -0800
@@ -555,7 +555,7 @@ else
 fi
 
 USER_OPTION=""
-if test -w / -o "$USER" = "root"
+if test -w /sbin -o "$USER" = "root"
 then
   if test "$user" != "root" -o $SET_USER = 1
   then
--- old/scripts/mysql_config.sh 2010-11-02 15:01:13.000000000 -0700
+++ new/scripts/mysql_config.sh 2010-12-14 12:34:31.000000000 -0800
@@ -133,7 +133,8 @@ for remove in DDBUG_OFF DSAFE_MUTEX DUNI
               DEXTRA_DEBUG DHAVE_purify O 'O[0-9]' 'xO[0-9]' 'W[-A-Za-z]*' \
               'mtune=[-A-Za-z0-9]*' 'mcpu=[-A-Za-z0-9]*' 'march=[-A-Za-z0-9]*' \
               Xa xstrconst "xc99=none" AC99 \
-              unroll2 ip mp restrict
+              unroll2 ip mp restrict \
+              mmmx 'msse[0-9.]*' 'mfpmath=sse' w pipe 'fomit-frame-pointer' 'mmacosx-version-min=10.[0-9]'
 do
   # The first option we might strip will always have a space before it because
   # we set -I$pkgincludedir as the first option
