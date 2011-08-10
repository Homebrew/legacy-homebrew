require 'formula'
require 'hardware'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp9.us.postgresql.org/pub/mirrors/postgresql/source/v9.0.4/postgresql-9.0.4.tar.bz2'
  md5 '80390514d568a7af5ab61db1cda27e29'

  depends_on 'readline'
  depends_on 'libxml2' if MacOS.leopard? # Leopard libxml is too old
  depends_on 'ossp-uuid'

  def options
    [
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.'],
      ['--enable-dtrace', 'Build with DTrace support.']
    ]
  end

  skip_clean :all

  def install
    ENV.libxml2 if MacOS.snow_leopard?

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--enable-thread-safety",
            "--with-bonjour",
            "--with-gssapi",
            "--with-krb5",
            "--with-openssl",
            "--with-libxml", "--with-libxslt"]

    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'
    args << "--enable-dtrace" if ARGV.include? '--enable-dtrace'

    args << "--with-ossp-uuid"

    args << "--datadir=#{share}/#{name}"
    args << "--docdir=#{doc}"

    ENV.append 'CFLAGS', `uuid-config --cflags`.strip
    ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
    ENV.append 'LIBS', `uuid-config --libs`.strip

    if MacOS.prefer_64_bit? and not ARGV.include? '--no-python'
      args << "ARCHFLAGS='-arch x86_64'"
      check_python_arch
    end

    # Fails on Core Duo with O4 and O3
    ENV.O2 if Hardware.intel_family == :core

    system "./configure", *args
    system "make install"
    system "make install-docs"

    contrib_directories = Dir.glob("contrib/*").select{ |path| File.directory?(path) } - ['contrib/start-scripts']

    contrib_directories.each do |contrib_directory|
      system "cd #{contrib_directory}; make install"
    end

    (prefix+'org.postgresql.postgres.plist').write startup_plist
  end

  def check_python_arch
    # On 64-bit systems, we need to look for a 32-bit Framework Python.
    # The configure script prefers this Python version, and if it doesn't
    # have 64-bit support then linking will fail.
    framework_python = Pathname.new "/Library/Frameworks/Python.framework/Versions/Current/Python"
    return unless framework_python.exist?
    unless (archs_for_command framework_python).include? :x86_64
      opoo "Detected a framework Python that does not have 64-bit support in:"
      puts <<-EOS.undent
          #{framework_python}

        The configure script seems to prefer this version of Python over any others,
        so you may experience linker problems as described in:
          http://osdir.com/ml/pgsql-general/2009-09/msg00160.html

        To fix this issue, you may need to either delete the version of Python
        shown above, or move it out of the way before brewing PostgreSQL.

        Note that a framework Python in /Library/Frameworks/Python.framework is
        the "MacPython" verison, and not the system-provided version which is in:
          /System/Library/Frameworks/Python.framework
      EOS
    end
  end

  def caveats
    s = <<-EOS
If builds of PostgreSQL 9 are failing and you have version 8.x installed,
you may need to remove the previous version first. See:
  https://github.com/mxcl/homebrew/issues/issue/2510

To build plpython against a specific Python, set PYTHON prior to brewing:
  PYTHON=/usr/local/bin/python  brew install postgresql
See:
  http://www.postgresql.org/docs/9.0/static/install-procedure.html


If this is your first install, create a database with:
  initdb #{var}/postgres

If this is your first install, automatically load on login with:
  mkdir -p ~/Library/LaunchAgents
  cp #{prefix}/org.postgresql.postgres.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

If this is an upgrade and you already have the org.postgresql.postgres.plist loaded:
  launchctl unload -w ~/Library/LaunchAgents/org.postgresql.postgres.plist
  cp #{prefix}/org.postgresql.postgres.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist

Or start manually with:
  pg_ctl -D #{var}/postgres -l #{var}/postgres/server.log start

And stop with:
  pg_ctl -D #{var}/postgres stop -s -m fast


Some machines may require provisioning of shared memory:
  http://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC
EOS

    if MacOS.prefer_64_bit? then
      s << <<-EOS

If you want to install the postgres gem, including ARCHFLAGS is recommended:
    env ARCHFLAGS="-arch x86_64" gem install pg

To install gems without sudo, see the Homebrew wiki.
      EOS
    end

    return s
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
  <string>org.postgresql.postgres</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/postgres</string>
    <string>-D</string>
    <string>#{var}/postgres</string>
    <string>-r</string>
    <string>#{var}/postgres/server.log</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
</dict>
</plist>
    EOPLIST
  end
end
