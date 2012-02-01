require 'formula'

class Mariadb < Formula
  # You probably don't want to have this and MySQL's formula linked at the same time
  # Just saying.
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.2.10/kvm-tarbake-jaunty-x86/mariadb-5.2.10.tar.gz'
  homepage 'http://mariadb.org/'
  md5 'c47fa6448476b06bb15788d3f23e2ae8'

  depends_on 'readline'

  def patches
    # upstream patches to fix compilation failures on OS X
    # will be present in next release
    { :p0 => ['http://bazaar.launchpad.net/~maria-captains/maria/5.2/diff/3085',
              'http://bazaar.launchpad.net/~maria-captains/maria/5.2/diff/3075.1.1',
              'http://bazaar.launchpad.net/~maria-captains/maria/5.2/diff/3094'] }
  end

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
      ['--universal', "Make mariadb a universal binary"]
    ]
  end

  def install
    ENV.append 'CXXFLAGS', '-fno-omit-frame-pointer -felide-constructors'

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
      "--without-readline",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--with-big-tables",
      "--with-plugin-aria",
      "--with-aria-tmp-tables",
      "--without-plugin-innodb_plugin",
      "--with-mysqld-ldflags=-static",
      "--with-client-ldflags=-static",
      "--with-plugins=max-no-ndb",
      "--with-embedded-server",
      "--with-libevent",
    ]

    configure_args << "--without-server" if ARGV.include? '--client-only'

    system "./configure", *configure_args
    system "make install"

    ln_s "#{libexec}/mysqld", bin
    ln_s "#{share}/mysql/mysql.server", bin

    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests' # save 121MB!
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    (prefix+'com.mysql.mysqld.plist').write startup_plist
    (prefix+'com.mysql.mysqld.plist').chmod 0644
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
