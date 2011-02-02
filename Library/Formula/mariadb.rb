require 'formula'

# This is based on the mysql formula
class Mariadb < Formula
  homepage 'http://mariadb.org/'
  url 'http://askmonty.org/downloads/r/http://ftp.osuosl.org/pub/mariadb/mariadb-5.1.53/kvm-tarbake-jaunty-x86/mariadb-5.1.53.tar.gz'
  md5 'be7e170ebc65420563c77770233b55c7'

  depends_on 'readline'

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
      ['--universal', "Make mysql a universal binary"]
    ]
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
      "--sysconfdir=#{etc}",
      "--with-plugins=maria,myisam,xtradb,innodb_plugin,pbxt",
      "--with-extra-charsets=complex",
      "--with-ssl",
      "--without-readline", # Confusingly, means "use detected readline instead of included readline"
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--enable-shared"]

    configure_args << "--without-server" if ARGV.include? '--client-only'

    system "./configure", *configure_args
    system "make install"

    ln_s "#{libexec}/mysqld", bin
    ln_s "#{share}/mysql/mysql.server", bin

    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests' # save 66MB!
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
