require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.1.4/postgresql-9.1.4.tar.bz2'
  md5 'a8035688dba988b782725ac1aec60186'

  depends_on 'readline'
  depends_on 'libxml2' if MacOS.leopard? # Leopard libxml is too old
  depends_on 'ossp-uuid'

  def options
    [
      ['--32-bit', 'Build 32-bit only.'],
      ['--without-ossp-uuid', 'Build without OSSP uuid.'],
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.'],
      ['--enable-dtrace', 'Build with DTrace support.'],
      ['--universal', 'Build with universal binaries and libraries.']
    ]
  end

  skip_clean :all

  # Fix PL/Python build: https://github.com/mxcl/homebrew/issues/11162
  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  def patches
    DATA
  end

  def install
    ENV.libxml2 if MacOS.snow_leopard?
    ENV.universal_binary if ARGV.build_universal?

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--datadir=#{share}/#{name}",
            "--docdir=#{doc}",
            "--enable-thread-safety",
            "--with-bonjour",
            "--with-gssapi",
            "--with-krb5",
            "--with-openssl",
            "--with-libxml",
            "--with-libxslt"]

    args << "--with-ossp-uuid" unless ARGV.include? '--without-ossp-uuid'
    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'
    args << "--enable-dtrace" if ARGV.include? '--enable-dtrace'

    ENV.append 'CFLAGS', `uuid-config --cflags`.strip
    ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
    ENV.append 'LIBS', `uuid-config --libs`.strip

    if not ARGV.build_32_bit? and MacOS.prefer_64_bit? and not ARGV.include? '--no-python'
      args << "ARCHFLAGS='-arch x86_64'"
      check_python_arch
    end

    if ARGV.build_32_bit?
      ENV.append 'CFLAGS', '-arch i386'
      ENV.append 'LDFLAGS', '-arch i386'
    end

    # Fails on Core Duo with O4 and O3
    ENV.O2 if Hardware.intel_family == :core

    system "./configure", *args
    if ENV.universal_binary
      system "curl https://trac.macports.org/export/96361/trunk/dports/databases/postgresql91/files/pg_config.h.ed | ed - ./src/include/pg_config.h"
      system "curl https://trac.macports.org/export/96361/trunk/dports/databases/postgresql91/files/ecpg_config.h.ed | ed  - ./src/interfaces/ecpg/include/ecpg_config.h"
    system "make install-world"

    plist_path.write startup_plist
    plist_path.chmod 0644
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
        the "MacPython" version, and not the system-provided version which is in:
          /System/Library/Frameworks/Python.framework
      EOS
    end
  end

  def caveats
    s = <<-EOS
# Build Notes

If builds of PostgreSQL 9 are failing and you have version 8.x installed,
you may need to remove the previous version first. See:
  https://github.com/mxcl/homebrew/issues/issue/2510

To build plpython against a specific Python, set PYTHON prior to brewing:
  PYTHON=/usr/local/bin/python  brew install postgresql
See:
  http://www.postgresql.org/docs/9.1/static/install-procedure.html

# Create/Upgrade a Database

If this is your first install, create a database with:
  initdb #{var}/postgres

To migrate existing data from a previous major version (pre-9.1) of PostgreSQL, see:
  http://www.postgresql.org/docs/9.1/static/upgrading.html

# Start/Stop PostgreSQL

If this is your first install, automatically load on login with:
  mkdir -p ~/Library/LaunchAgents
  cp #{plist_path} ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

If this is an upgrade and you already have the #{plist_path.basename} loaded:
  launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
  cp #{plist_path} ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

Or start manually with:
  pg_ctl -D #{var}/postgres -l #{var}/postgres/server.log start

And stop with:
  pg_ctl -D #{var}/postgres stop -s -m fast

# Loading Extensions

By default, Homebrew builds all available Contrib extensions.  To see a list of all
available extensions, from the psql command line, run:
  SELECT * FROM pg_available_extensions;

To load any of the extension names, navigate to the desired database and run:
  CREATE EXTENSION [extension name];

For instance, to load the tablefunc extension in the current database, run:
  CREATE EXTENSION tablefunc;

For more information on the CREATE EXTENSION command, see:
  http://www.postgresql.org/docs/9.1/static/sql-createextension.html
For more information on extensions, see:
  http://www.postgresql.org/docs/9.1/static/contrib.html

# Other

Some machines may require provisioning of shared memory:
  http://www.postgresql.org/docs/current/static/kernel-resources.html#SYSVIPC
EOS

    if MacOS.prefer_64_bit? then
      s << <<-EOS

To install postgresql (and ossp-uuid) in 32-bit mode:
   brew install postgresql --32-bit

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
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/bin/postgres</string>
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
  <key>StandardErrorPath</key>
  <string>#{var}/postgres/server.log</string>
</dict>
</plist>
    EOPLIST
  end
end


__END__
--- a/src/pl/plpython/Makefile	2011-09-23 08:03:52.000000000 +1000
+++ b/src/pl/plpython/Makefile	2011-10-26 21:43:40.000000000 +1100
@@ -24,8 +24,6 @@
 # Darwin (OS X) has its own ideas about how to do this.
 ifeq ($(PORTNAME), darwin)
 shared_libpython = yes
-override python_libspec = -framework Python
-override python_additional_libs =
 endif
 
 # If we don't have a shared library and the platform doesn't allow it
--- a/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c	2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
