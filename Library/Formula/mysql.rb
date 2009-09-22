require 'brewkit'

class Mysql <Formula
  @url='http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.39.zip'
  @homepage='http://dev.mysql.com/doc/refman/5.1/en/'
  @md5='93972105209abdc72c450c0c60f0e404'

  depends_on 'readline'

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
    ]
  end

  def patches
    DATA
  end

  def install
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"

    configure_args = [
      "--without-bench",
      "--without-docs",
      "--without-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--with-plugins=innobase,myisam",
      "--with-extra-charsets=complex",
      "--with-plugins=innobase,myisam",
      "--with-ssl",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--enable-shared"]

    configure_args << "--without-server" if ARGV.include? '--client-only'

    system "./configure", *configure_args
    system "make install"

    # Why does sql-bench still get built w/ above options?
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    # save 66MB!
    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests'

    var.mkpath

    (prefix+'com.mysql.mysqld.plist').write startup_plist
  end

  def caveats
    puts "Set up databases with `mysql_install_db`"
    puts "Automatically load on login with "
    puts "  `launchctl load -w #{prefix}/com.mysql.mysqld.plist`"
    puts "Or start manually with "
    puts "  `#{prefix}/share/mysql/mysql.server start`"
  end

  def startup_plist
    return <<-EOPLIST
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
  <string>#{`whoami`}</string>
  <key>WorkingDirectory</key>
  <string>/usr/local</string>
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
