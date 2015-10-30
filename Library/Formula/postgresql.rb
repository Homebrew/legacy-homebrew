class Postgresql < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"

  stable do
    url "https://ftp.postgresql.org/pub/source/v9.4.5/postgresql-9.4.5.tar.bz2"
    sha256 "b87c50c66b6ea42a9712b5f6284794fabad0616e6ae420cf0f10523be6d94a39"
  end

  devel do
    url "https://ftp.postgresql.org/pub/source/v9.5beta1/postgresql-9.5beta1.tar.bz2"
    sha256 "b53199e2667982de2039ad7e30467f67c5d7af678e69d6211de8ba1cac75c9f0"
    version "9.5beta1"
  end

  bottle do
    sha256 "57294da21442db822bf719143880000c9a90656188dcf580fafcb6b4e4350f9e" => :el_capitan
    sha256 "02a136458ee09cc7fdb731c023948359dafa5665b56179744985864492adacd4" => :yosemite
    sha256 "13f6fec00aa8b4938a2858bdcda390460d21bb71d16fc0827bf8446071c60f47" => :mavericks
  end

  option "32-bit"
  option "without-perl", "Build without Perl support"
  option "without-tcl", "Build without Tcl support"
  option "with-dtrace", "Build with DTrace support"
  option "with-pgroonga", "Build with the PGroonga postgresql extension"

  deprecated_option "no-perl" => "without-perl"
  deprecated_option "no-tcl" => "without-tcl"
  deprecated_option "enable-dtrace" => "with-dtrace"

  depends_on "openssl"
  depends_on "readline"
  depends_on "libxml2" if MacOS.version <= :leopard # Leopard libxml is too old
  depends_on :python => :optional

  if build.with? "pgroonga"
    depends_on "groonga" => :build
    depends_on "pkg-config" => :build
  end

  resource "pgroonga" do
    url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.0.tar.gz"
    sha256 "854d66bdc79e7cfceb29ae8706556a3ad1c8b32ac4535939d296966e3b19fd3e"
  end

  conflicts_with "postgres-xc",
    :because => "postgresql and postgres-xc install the same binaries."

  fails_with :clang do
    build 211
    cause "Miscompilation resulting in segfault on queries"
  end

  def install
    ENV.libxml2 if MacOS.version >= :snow_leopard

    ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"
    ENV.prepend "CPPLAGS", "-I#{Formula["openssl"].opt_include}"

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
    system "make", "install-world"

    if build.with? "pgroonga"
      resource("pgroonga").stage do
        ENV.append_path "PATH", bin
        system "make"
        system "make", "install"
      end
    end
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
  end
end
