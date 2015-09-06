class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.9.tar.bz2"
  mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-3.0.9.tar.bz2"
  sha256 "030d9bfe5ef42d0fd4be94a1fe03a60af9dff35b7ee89e50b0a73ff78606f7e9"

  bottle do
    sha256 "8843ce6b2cacf638f211ff039a32c7f2a30e605fddf593d79760ceff52bd6a27" => :yosemite
    sha256 "8485f3a73083a46f0b0c44b2351727db28c2ba3da6dce72c0f7737615d1b9f45" => :mavericks
    sha256 "bfb6f2e71540d9a7763d242463bad1197e531825f84f7b1c1b09ad7ab7cde089" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "talloc"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl"].opt_include}
      --with-openssl-libraries=#{Formula["openssl"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

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
