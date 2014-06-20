require 'formula'

class Postgresql < Formula
  homepage 'http://www.postgresql.org/'

  stable do
    url 'http://ftp.postgresql.org/pub/source/v9.3.4/postgresql-9.3.4.tar.bz2'
    sha256 '9ee819574dfc8798a448dc23a99510d2d8924c2f8b49f8228cd77e4efc8a6621'

    # ossp-uuid support cannot be compiled on 9.4beta1:
    # http://thread.gmane.org/gmane.comp.db.postgresql.devel.general/229339
    # Will keep it stable-only until the usptream issues are resolved.
    depends_on 'ossp-uuid' => :recommended
    # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
    patch :DATA
  end

  bottle do
    revision 2
    sha1 "a97e4f9364fd4518cc492135ac11832d4f8001c6" => :mavericks
    sha1 "5c10d677a07a8055bfd21f94633f6d897e4a60f7" => :mountain_lion
    sha1 "7da81a9d1dd086d6b1403d9a508d5871c85d2892" => :lion
  end

  devel do
    url 'http://ftp.postgresql.org/pub/source/v9.4beta1/postgresql-9.4beta1.tar.bz2'
    version '9.4beta1'
    sha256 '0e088eff79bb5171b2233222a25d7a2906eaf62aa86266daf6ec5217b1797f47'
  end

  option '32-bit'
  option 'no-perl', 'Build without Perl support'
  option 'no-tcl', 'Build without Tcl support'
  option 'enable-dtrace', 'Build with DTrace support'

  depends_on 'openssl'
  depends_on 'readline'
  depends_on 'libxml2' if MacOS.version <= :leopard # Leopard libxml is too old
  depends_on :python => :optional

  conflicts_with 'postgres-xc',
    :because => 'postgresql and postgres-xc install the same binaries.'

  fails_with :clang do
    build 211
    cause 'Miscompilation resulting in segfault on queries'
  end

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{share}/#{name}
      --docdir=#{doc}
      --enable-thread-safety
      --with-bonjour
      --with-gssapi
      --with-ldap
      --with-openssl
      --with-pam
      --with-libxml
      --with-libxslt
    ]

    args << "--with-python" if build.with? 'python'
    args << "--with-perl" unless build.include? 'no-perl'
    args << "--with-tcl" unless build.include? 'no-tcl'
    args << "--enable-dtrace" if build.include? 'enable-dtrace'

    if build.stable? && build.with?("ossp-uuid")
      args << "--with-ossp-uuid"
      ENV.append 'CFLAGS', `uuid-config --cflags`.strip
      ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
      ENV.append 'LIBS', `uuid-config --libs`.strip
    end

    if build.build_32_bit?
      ENV.append 'CFLAGS', "-arch #{MacOS.preferred_arch}"
      ENV.append 'LDFLAGS', "-arch #{MacOS.preferred_arch}"
    end

    system "./configure", *args
    system "make install-world"
  end

  def post_install
    unless File.exist? "#{var}/postgres"
      system "#{bin}/initdb", "#{var}/postgres"
    end
  end

  def caveats
    s = <<-EOS.undent
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/homebrew/issues/issue/2510

    To migrate existing data from a previous major version (pre-9.3) of PostgreSQL, see:
      http://www.postgresql.org/docs/9.3/static/upgrading.html
    EOS

    s << "\n" << gem_caveats if MacOS.prefer_64_bit?
    return s
  end

  def gem_caveats; <<-EOS.undent
    When installing the postgres gem, including ARCHFLAGS is recommended:
      ARCHFLAGS="-arch x86_64" gem install pg

    To install gems without sudo, see the Homebrew wiki.
    EOS
  end

  plist_options :manual => "postgres -D #{HOMEBREW_PREFIX}/var/postgres"

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
        <string>#{opt_bin}/postgres</string>
        <string>-D</string>
        <string>#{var}/postgres</string>
        <string>-r</string>
        <string>#{var}/postgres/server.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/postgres/server.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/initdb", testpath
  end
end


__END__
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
