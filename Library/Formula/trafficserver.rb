class Trafficserver < Formula
  desc "HTTP/1.1 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=trafficserver/trafficserver-6.0.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-6.0.0.tar.bz2"
  sha256 "1ef6a9ed1d53532bbe2c294d86d4103a0140e3f23a27970936366f1bc8feb3d1"

  bottle do
    revision 1
    sha256 "8d0b4c85d37dac8a9cf65ab3acca59cc3a6547483fb107216c47834f757d14f4" => :el_capitan
    sha256 "43f1e10be22b343163cad886fcc0d291183898a8b213000e2c1dd94bfdebe5d4" => :yosemite
    sha256 "4c5af536e2b066b98d06829a298ab1242ac8ba28abd65b35b2b1c0937ed45ea4" => :mavericks
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
      --sysconfdir=#{etc}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-user=#{ENV["USER"]}
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

  test do
    assert_match "Apache Traffic Server is not running.", shell_output("#{bin}/trafficserver status").chomp
  end
end
