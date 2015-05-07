class Postgresql < Formula
  homepage "http://www.postgresql.org/"
  revision 1

  stable do
    url "http://ftp.postgresql.org/pub/source/v9.4.1/postgresql-9.4.1.tar.bz2"
    sha256 "29ddb77c820095b8f52e5455e9c6c6c20cf979b0834ed1986a8857b84888c3a6"
  end

  bottle do
    revision 1
    sha1 "4b5a1f7ebe10ec5aba088459a4faa2ba7c13a691" => :yosemite
    sha1 "e7844fc53d1ffef1cb809332d88b5bb777927176" => :mavericks
    sha1 "a5e70e04dba89fee99bb5fb7dae74e4a849813c4" => :mountain_lion
  end

  option "32-bit"
  option "without-perl", "Build without Perl support"
  option "without-tcl", "Build without Tcl support"
  option "with-dtrace", "Build with DTrace support"

  deprecated_option "no-perl" => "without-perl"
  deprecated_option "no-tcl" => "without-tcl"
  deprecated_option "enable-dtrace" => "with-dtrace"

  depends_on "openssl"
  depends_on "readline"
  depends_on "libxml2" if MacOS.version <= :leopard # Leopard libxml is too old
  depends_on :python => :optional

  conflicts_with "postgres-xc",
    :because => "postgresql and postgres-xc install the same binaries."

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  def pg_version
    version.to_s[/^\d\.\d/]
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

    args << "--with-python" if build.with? "python"
    args << "--with-perl" if build.with? "perl"

    # The CLT is required to build tcl support on 10.7 and 10.8 because
    # tclConfig.sh is not part of the SDK
    if build.with?("tcl") && (MacOS.version >= :mavericks || MacOS::CLT.installed?)
      args << "--with-tcl"

      if File.exist?("#{MacOS.sdk_path}/usr/lib/tclConfig.sh")
        args << "--with-tclconfig=#{MacOS.sdk_path}/usr/lib"
      end
    end

    args << "--enable-dtrace" if build.with? "dtrace"
    args << "--with-uuid=e2fs"

    if build.build_32_bit?
      ENV.append %w{CFLAGS LDFLAGS}, "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "./configure", *args
    system "make", "install-world"
  end

  def post_install
    if File.exist? "#{var}/postgres"
      return
    end

    if File.exist? "#{var}/postgres/PG_VERSION"
      existing_pg_version = (var/"postgres/PG_VERSION").read.chomp
    end

    # With the 9.5 release, we'll need to adapt logic to make sure we preserve the
    # 9.4 var directories, without breaking postgres. This should be able to be done
    # by modifying some lines below to var/"postgres-9.4" instead of var/"postgres"
    current_data = var/"postgres"
    backup_path = var/"postgres-#{pg_version}"
    # This should always be the last full version shipped by Brew, i.e. 9.4.0.
    prior_ver = File.basename Dir[HOMEBREW_CELLAR/"postgresql/#{existing_pg_version}*/"].first

    if (var/"postgres").exist?
      if Dir["#{backup_path}/*"].empty?
        mkdir_p backup_path
        cp_r Dir["#{current_data}/*"], backup_path
        puts "Data copied up from #{current_data} to #{backup_path}"
      else
        opoo "#{backup_path} is not empty; Not automatically copying data across."
      end
    else
      system "#{bin}/initdb", current_data
    end

    unless Dir["#{HOMEBREW_CELLAR}/postgresql/#{current_data}"].empty?
      ENV["PGDATANEW"] = "#{backup_path}"
      ENV["PGDATAOLD"] = "#{current_data}"
      ENV["PGBINOLD"] = "#{HOMEBREW_CELLAR}/postgresql/#{prior_ver}/bin"
      ENV["PGBINNEW"] = "#{Formula["postgresql"].opt_bin}"
      system "#{bin}/pg_upgrade"
      puts "Database upgraded to the latest format."
    end
  end

  def caveats; <<-EOS.undent
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/homebrew/issues/2510
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
    system "#{bin}/initdb", testpath/"test"
  end
end
