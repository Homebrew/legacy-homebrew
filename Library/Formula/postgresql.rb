require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.2.3/postgresql-9.2.3.tar.bz2'
  sha1 'fe46685c36f6a7a04edd67be5695b4f5acebedff'

  depends_on 'readline'
  depends_on 'libxml2' if MacOS.version == :leopard # Leopard libxml is too old
  depends_on 'ossp-uuid' => :recommended

  conflicts_with 'postgres-xc',
    :because => 'postgresql and postgres-xc install the same binaries.'

  option '32-bit'
  option 'no-python', 'Build without Python support'
  option 'no-perl', 'Build without Perl support'
  option 'enable-dtrace', 'Build with DTrace support'

  fails_with :clang do
    build 211
    cause 'Miscompilation resulting in segfault on queries'
  end

  # Fix PL/Python build: https://github.com/mxcl/homebrew/issues/11162
  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  def patches
    DATA
  end

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

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

    args << "--with-ossp-uuid" if build.with? 'ossp-uuid'
    args << "--with-python" unless build.include? 'no-python'
    args << "--with-perl" unless build.include? 'no-perl'
    args << "--enable-dtrace" if build.include? 'enable-dtrace'

    if build.with? 'ossp-uuid'
      ENV.append 'CFLAGS', `uuid-config --cflags`.strip
      ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
      ENV.append 'LIBS', `uuid-config --libs`.strip
    end

    if not build.build_32_bit? and MacOS.prefer_64_bit? and not build.include? 'no-python'
      args << "ARCHFLAGS='-arch x86_64'"
      check_python_arch
    end

    if build.build_32_bit?
      ENV.append 'CFLAGS', '-arch i386'
      ENV.append 'LDFLAGS', '-arch i386'
    end

    system "./configure", *args
    system "make install-world"
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
    s = <<-EOS.undent
    # Build Notes

    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/mxcl/homebrew/issues/issue/2510

    To build plpython against a specific Python, set PYTHON prior to brewing:
      PYTHON=/usr/local/bin/python  brew install postgresql
    See:
      http://www.postgresql.org/docs/9.2/static/install-procedure.html

    # Create/Upgrade a Database

    If this is your first install, create a database with:
      initdb #{var}/postgres -E utf8

    To migrate existing data from a previous major version (pre-9.2) of PostgreSQL, see:
      http://www.postgresql.org/docs/9.2/static/upgrading.html

    # Loading Extensions

    By default, Homebrew builds all available Contrib extensions.  To see a list of all
    available extensions, from the psql command line, run:
      SELECT * FROM pg_available_extensions;

    To load any of the extension names, navigate to the desired database and run:
      CREATE EXTENSION [extension name];

    For instance, to load the tablefunc extension in the current database, run:
      CREATE EXTENSION tablefunc;

    For more information on the CREATE EXTENSION command, see:
      http://www.postgresql.org/docs/9.2/static/sql-createextension.html
    For more information on extensions, see:
      http://www.postgresql.org/docs/9.2/static/contrib.html

    # Other

    Some machines may require provisioning of shared memory:
      http://www.postgresql.org/docs/9.2/static/kernel-resources.html#SYSVIPC
    EOS

    if MacOS.prefer_64_bit? then
      s << <<-EOS.undent

      To install postgresql (and ossp-uuid) in 32-bit mode:
         brew install postgresql --32-bit

      If you want to install the postgres gem, including ARCHFLAGS is recommended:
          env ARCHFLAGS="-arch x86_64" gem install pg

      To install gems without sudo, see the Homebrew wiki.
      EOS
    end

    return s
  end

  plist_options :manual => "pg_ctl -D #{HOMEBREW_PREFIX}/var/postgres -l #{HOMEBREW_PREFIX}/var/postgres/server.log start"

  def plist; <<-EOS.undent
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
        <string>#{opt_prefix}/bin/postgres</string>
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
    EOS
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
