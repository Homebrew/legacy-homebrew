class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "http://freeradius.org/"

  stable do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.7.tar.bz2"
    mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-2.2.7.tar.bz2"
    sha256 "6b0af62ded0fda9bb24aee568c3bc9e5f0c0b736530df3c1260e2b6085f2e5f9"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  devel do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.8.tar.bz2"
    mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-3.0.8.tar.bz2"
    sha256 "b89721c609e5a106936112fe8122e470f02a5197bb614e202d2c386f4821d902"
    depends_on "talloc" => :build
  end

  bottle do
    sha256 "8843ce6b2cacf638f211ff039a32c7f2a30e605fddf593d79760ceff52bd6a27" => :yosemite
    sha256 "8485f3a73083a46f0b0c44b2351727db28c2ba3da6dce72c0f7737615d1b9f45" => :mavericks
    sha256 "bfb6f2e71540d9a7763d242463bad1197e531825f84f7b1c1b09ad7ab7cde089" => :mountain_lion
  end

  depends_on "openssl"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl"].opt_include}
      --with-openssl-libraries=#{Formula["openssl"].opt_lib}
    ]

    if build.stable?
      # libtool is glibtool on OS X
      inreplace "configure.in", "libtool,,", "glibtool,,"
      inreplace "autogen.sh", "libtool", "glibtool"

      args << "--with-system-libtool"
      args << "--with-system-libltdl"
      system "./autogen.sh"
    end

    if build.devel?
      args << "--with-talloc-lib-dir=#{Formula["talloc"].opt_lib}"
      args << "--with-talloc-include-dir=#{Formula["talloc"].opt_include}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match /77C8009C912CFFCF3832C92FC614B7D1/, shell_output("#{bin}/smbencrypt homebrew")
  end
end
