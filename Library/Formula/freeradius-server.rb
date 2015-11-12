class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.9.tar.bz2"
  mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-3.0.9.tar.bz2"
  sha256 "030d9bfe5ef42d0fd4be94a1fe03a60af9dff35b7ee89e50b0a73ff78606f7e9"

  bottle do
    sha256 "2a7bd5d5c1f586759be42d466ea4b4f8eb4d6302080b3419b06f3f264e507b0f" => :yosemite
    sha256 "321acc149270fba2040f3d248b0de7aceb07efc1abfe0a89cb44063886c9a135" => :mavericks
    sha256 "d27bcb30a5d4ad39ab29b0faf2462163a2a177300817af8c324bab2c44593f65" => :mountain_lion
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
