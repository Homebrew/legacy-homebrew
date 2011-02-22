require 'formula'

class Mysql <Formula
  homepage 'http://dev.mysql.com/doc/refman/5.5/en/'
  url 'http://ftp.sunet.se/pub/unix/databases/relational/mysql/Downloads/MySQL-5.5/mysql-5.5.9.tar.gz'
  md5 '701c0c44b7f1c2300adc0dc45729f903'

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
