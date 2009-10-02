require 'brewkit'

class Mysql <Formula
  @homepage='http://dev.mysql.com/doc/refman/5.1/en/'
  @url='http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.39.tar.gz'
  @md5='55a398daeb69a778fc46573623143268'

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
    # See: http://dev.mysql.com/doc/refman/5.1/en/configure-options.html
    # These flags may not apply to gcc 4+
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"

    configure_args = [
      "--without-docs",
      "--without-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}/mysql",
      "--with-plugins=innobase,myisam",
      "--with-extra-charsets=complex",
      "--with-ssl",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--enable-shared"]

    configure_args << "--without-server" if ARGV.include? '--client-only'

    system "./configure", *configure_args
    system "make install"

    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests' # save 66MB!
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    (prefix+'com.mysql.mysqld.plist').write startup_plist
  end

  def caveats; <<-EOS
Set up databases with:
    mysql_install_db

Automatically load on login with:
    launchctl load -w #{prefix}/com.mysql.mysqld.plist

Or start manually with:
    #{prefix}/share/mysql/mysql.server start
    EOS
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
  <string>#{HOMEBREW_PREFIX}</string>
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
