require 'brewkit'

class Mysql <Formula
  @url='http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.37.zip'
  @homepage='http://dev.mysql.com/doc/refman/5.1/en/'
  @md5='7564d7759a8077b3a0e6190955422287'

  def deps
    # --without-readline means use system's readline
    LibraryDep.new 'readline'
  end

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
    ]
  end

  def patches
    {:p1 => "http://gist.github.com/raw/179616/bcbc9f185bbd353934c9379a253d23269c65170e/Diff"}
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
