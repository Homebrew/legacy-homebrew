require "formula"

# GnuTLS has previous, current, and next stable branches, we use current.
# From 3.4.0 GnuTLS will be permanently disabling SSLv3. Every brew uses will need a revision with that.
# http://nmav.gnutls.org/2014/10/what-about-poodle.html
class Gnutls < Formula
  homepage "http://gnutls.org"
  url "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.3/gnutls-3.3.10.tar.xz"
  mirror "http://mirrors.dotsrc.org/gcrypt/gnutls/v3.3/gnutls-3.3.10.tar.xz"
  sha256 "e27553981d48d9211a7e5e94f6e78c575205202a181c2345a1c8466ebf1d2219"

  bottle do
    cellar :any
    sha1 "5d22a5706f229e27b48c3279b8c6139f5e273a0c" => :yosemite
    sha1 "b6636c0b6a7d85c263b911bf3d75019bde1fb7eb" => :mavericks
    sha1 "348f799829b8e62ce0544a9caacdf2e2ebb1508e" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "gmp"
  depends_on "nettle"
  depends_on "guile" => :optional
  depends_on "p11-kit" => :optional
  depends_on "unbound" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
      --disable-heartbeat-support
    ]

    if build.with? "guile"
      args << "--enable-guile"
      args << "--with-guile-site-dir=no"
    end

    system "./configure", *args
    system "make", "install"

    # certtool shadows the OS X certtool utility
    mv bin+"certtool", bin+"gnutls-certtool"
    mv man1+"certtool.1", man1+"gnutls-certtool.1"
  end

  def post_install
    Formula["openssl"].post_install
  end

  test do
    system "#{bin}/gnutls-cli", "--version"
  end
end
