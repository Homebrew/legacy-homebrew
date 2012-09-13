require 'formula'

class Mariadb < Formula
  homepage 'http://mariadb.org/'
  url 'http://ftp.osuosl.org/pub/mariadb/mariadb-5.5.27/kvm-tarbake-jaunty-x86/mariadb-5.5.27.tar.gz'
  sha1 '0f10c6294f44f4a595e2f96317a2b5e04a13ba4f'

  depends_on 'readline'
  depends_on 'cmake'

  option :universal
  option 'with-tests', 'Keep test when installing'
  option 'with-bench', 'Keep benchmark app when installing'
  option 'client-only', 'Install only client tools'

  conflicts_with 'mysql',
    :because => "mariadb and mysql install the same binaries."
  conflicts_with 'percona-server',
    :because => "mariadb and percona-server install the same binaries."

  fails_with :clang do
    build 421
  end

  def install
    # Build without compiler or CPU specific optimization flags to facilitate
    # compilation of gems and other software that queries `mysql-config`.
    ENV.minimal_optimization

    ENV.append 'CXXFLAGS', '-fno-omit-frame-pointer -felide-constructors'

    # Make universal for bindings to universal applications
    ENV.universal_binary if build.universal?

    cmake_args = [
      ".",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DMYSQL_DATADIR=#{var}/mysql",
      "-DWITH_EXTRA_CHARSETS=complex",
      "-DWITH_PLUGIN_ARIA=1",
      "-DWITH_MAX_NO_NDB=1",
      "-DWITH_EMBEDDED_SERVER=1",
      "-DWITH_READLINE=1",
      "-DINSTALL_SYSCONFDIR=#{etc}"
    ]

    cmake_args << "-DWITHOUT_SERVER=1" if build.include? 'client-only'

    system "cmake", *cmake_args
    system "make install"
    system "mv #{prefix}/man #{prefix}/share/man"

    bin.install_symlink "#{prefix}/support-files/mysql.server"

    (prefix+'mysql-test').rmtree unless build.include? 'with-tests' # save 121MB!
    (prefix+'sql-bench').rmtree unless build.include? 'with-bench'
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
