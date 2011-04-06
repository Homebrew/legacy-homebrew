require 'formula'

class Mariadb < Formula
  # You probably don't want to have this and MySQL's formula linked at the same time
  # Just saying.
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.2.6/kvm-tarbake-jaunty-x86/mariadb-5.2.6.tar.gz'
  homepage 'http://mariadb.org/'
  md5 'e562aca71ae16b490196f99aa7e64b55'

  depends_on 'readline'

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
      ['--universal', "Make mariadb a universal binary"]
    ]
  end

  def install
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"

    # Make universal for bindings to universal applications
    ENV.universal_binary if ARGV.build_universal?

    configure_args = [
      "--without-docs",
      "--without-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}/mysql",
      "--sysconfdir=#{etc}",
      "--with-extra-charsets=complex",
      "--with-ssl",
      "--without-readline",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--enable-shared",
      "--with-big-tables",
      "--with-plugins=xtradb",
      "--with-plugin-maria",
      "--with-maria-tmp-tables",
      "--without-plugin-innodb_plugin"
    ]

    configure_args << "--without-server" if ARGV.include? '--client-only'

    system "./configure", *configure_args
    system "make install"

    ln_s "#{libexec}/mysqld", bin
    ln_s "#{share}/mysql/mysql.server", bin

    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests' # save 121MB!
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    (prefix+'com.mysql.mysqld.plist').write startup_plist
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        mysql_install_db

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
        mysql.server start
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
--- old/scripts/mysqld_safe.sh	2009-09-02 04:10:39.000000000 -0400
+++ new/scripts/mysqld_safe.sh	2009-09-02 04:52:55.000000000 -0400
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
