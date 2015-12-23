class Postgresql < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  revision 2

  stable do
    url "https://ftp.postgresql.org/pub/source/v9.4.5/postgresql-9.4.5.tar.bz2"
    sha256 "b87c50c66b6ea42a9712b5f6284794fabad0616e6ae420cf0f10523be6d94a39"
  end

  bottle do
    sha256 "b57a3b65cd90917273d754f2625a83e69eac78aeff5b79573f8ac9811bdf643c" => :el_capitan
    sha256 "6b26ad24a228620e16d7f81b4f3bd183a80e1c2f02b8505a1a6b71356eec53a4" => :yosemite
    sha256 "a6a49e234543bb7c4fb33b64dd14b48da5b8373fb2110d62e82d7129997f4926" => :mavericks
  end

  devel do
    url "https://ftp.postgresql.org/pub/source/v9.5rc1/postgresql-9.5rc1.tar.bz2"
    sha256 "497c44b95accec23e38f7ee93fd42488bddfbdab4858ad94de18348b0913add3"
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

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPLAGS", "-I#{Formula["openssl"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{HOMEBREW_PREFIX}/share/postgresql
      --libdir=#{HOMEBREW_PREFIX}/lib
      --sysconfdir=#{etc}
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

    # The CLT is required to build Tcl support on 10.7 and 10.8 because
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
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "./configure", *args
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}/postgresql"
  end

  def post_install
    unless File.exist? "#{var}/postgres"
      system "#{bin}/initdb", "#{var}/postgres"
    end
  end

  def caveats; <<-EOS.undent
    If builds of PostgreSQL 9 are failing and you have version 8.x installed,
    you may need to remove the previous version first. See:
      https://github.com/Homebrew/homebrew/issues/2510

    To migrate existing data from a previous major version (pre-9.4) of PostgreSQL, see:
      https://www.postgresql.org/docs/9.4/static/upgrading.html
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
    assert_equal "#{HOMEBREW_PREFIX}/share/postgresql", shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib", shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/postgresql", shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end
