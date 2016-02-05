class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-6.0.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-6.0.0.tar.bz2"
  sha256 "1ef6a9ed1d53532bbe2c294d86d4103a0140e3f23a27970936366f1bc8feb3d1"

  bottle do
    revision 2
    sha256 "b815aa4c085ee9ea10064260fe58e0d46264d283915ceaac3f48ce96b1e94ac6" => :el_capitan
    sha256 "ab5d00a893335cc2cd763819b617d20b7c4675b4276bd665d2db6695d382f28c" => :yosemite
    sha256 "70f63d966cfbe960218fe8cc12b8fe5644a4d619642446ba45ec5a81fc99752c" => :mavericks
  end

  head do
    url "https://github.com/apache/trafficserver.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  option "with-spdy", "Build with SPDY protocol support"
  option "with-experimental-plugins", "Enable experimental plugins"

  depends_on "openssl"
  depends_on "pcre"

  if build.with? "spdy"
    depends_on "spdylay"
    depends_on "pkg-config" => :build
  end

  needs :cxx11

  def install
    ENV.cxx11
    # Needed for correct ./configure detections.
    ENV.enable_warnings
    # Needed for OpenSSL headers on Lion.
    ENV.append_to_cflags "-Wno-deprecated-declarations"
    # Fix lib/perl/Makefile.pl failing with:
    # Only one of PREFIX or INSTALL_BASE can be given.  Not both.
    ENV.delete "PERL_MM_OPT"

    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/trafficserver
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-group=admin
      --disable-silent-rules
    ]

    args << "--enable-spdy" if build.with? "spdy"
    args << "--enable-experimental-plugins" if build.with? "experimental-plugins"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args

    # Fix wrong username in the generated startup script for bottles.
    inreplace "rc/trafficserver.in", "@pkgsysuser@", "$USER"
    if build.with? "experimental-plugins"
      # Disable mysql_remap plugin due to missing symbol compile error:
      # https://issues.apache.org/jira/browse/TS-3490
      inreplace "plugins/experimental/Makefile", " mysql_remap", ""
    end

    system "make" if build.head?
    system "make", "install"
  end

  def post_install
    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    File.open("#{config}", "a") do |f|
      f.puts "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
    end
  end

  test do
    assert_match "Apache Traffic Server is not running.", shell_output("#{bin}/trafficserver status").chomp
  end
end
