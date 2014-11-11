require "formula"

class Postgresql < Formula
  homepage "http://www.postgresql.org/"
  revision 1

  stable do
    url "http://ftp.postgresql.org/pub/source/v9.3.5/postgresql-9.3.5.tar.bz2"
    sha256 "14176ffb1f90a189e7626214365be08ea2bfc26f26994bafb4235be314b9b4b0"

    # ossp-uuid is no longer required for uuid support since 9.4beta2:
    depends_on "ossp-uuid" => :recommended
    # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
    patch :DATA
  end

  bottle do
    revision 1
    sha1 "00d8f44111b8585fc2fa045fb33098cde3bcf230" => :yosemite
    sha1 "d298f4cd7fffa6b8b879ccc2c6d32fc191be41ed" => :mavericks
    sha1 "c5c5d23e95c1950d4b33865b8ebdce28b4e6706f" => :mountain_lion
    sha1 "860395322283401cfc1d0694984c272546f21fa9" => :lion
  end

  devel do
    url 'http://ftp.postgresql.org/pub/source/v9.4beta3/postgresql-9.4beta3.tar.bz2'
    version '9.4beta3'
    sha256 '5ad1d86a5b9a70d5c153dd862b306a930c6cf67fb4a3f00813eef19fabe6aa5d'
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

    # The CLT is required to build tcl support on 10.7 and 10.8 because
    # tclConfig.sh is not part of the SDK
    unless build.include?("no-tcl") || MacOS.version < :mavericks && MacOS::CLT.installed?
      args << "--with-tcl"

      if File.exist?("#{MacOS.sdk_path}/usr/lib/tclConfig.sh")
        args << "--with-tclconfig=#{MacOS.sdk_path}/usr/lib"
      end
    end

    args << "--enable-dtrace" if build.include? 'enable-dtrace'

    if build.with?("ossp-uuid")
      args << "--with-ossp-uuid"
      ENV.append 'CFLAGS', `uuid-config --cflags`.strip
      ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
      ENV.append 'LIBS', `uuid-config --libs`.strip
    elsif build.devel?
      # Apple's UUID implementation is compatible with e2fs NOT bsd
      args << "--with-uuid=e2fs"
    end

    if build.build_32_bit?
      ENV.append %w{CFLAGS LDFLAGS}, "-arch #{Hardware::CPU.arch_32_bit}"
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
