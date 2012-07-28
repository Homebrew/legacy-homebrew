require 'formula'

class Mariadb < Formula
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.3.7/kvm-tarbake-jaunty-x86/mariadb-5.3.7.tar.gz'
  homepage 'http://mariadb.org/'
  sha1 '1ee2ef4895aefabd66b4884c382ba2cd1f7bbe2d'

  depends_on 'readline'

  conflicts_with 'mysql',
    :because => "mariadb and mysql install the same binaries."
  conflicts_with 'percona-server',
    :because => "mariadb and percona-server install the same binaries."

  fails_with :clang do
    build 318
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

    bin.install_symlink "#{libexec}/mysqld"
    bin.install_symlink "#{share}/mysql/mysql.server"

    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests' # save 121MB!
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    Set up databases with:
        unset TMPDIR
        mysql_install_db

    If this is your first install, automatically load on login with:
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Note on upgrading:
        We overwrite any existing #{plist_path.basename} in ~/Library/LaunchAgents
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
