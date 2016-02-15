class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "http://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.11.tar.bz2"
  mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-3.0.11.tar.bz2"
  sha256 "2b6109b61fc93e9fcdd3dd8a91c3abbf0ce8232244d1d214d71a4e5b7faadb80"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "f9af8bbc1e73b136d2c0ae4249657ad262f84dc1b5ad6e898232f892da12439f" => :el_capitan
    sha256 "e375d987b6b7e1c74d4f53ea86a86dfa7c503a241c6fe0bccb3d7bc09619f09d" => :yosemite
    sha256 "ee57bf27930bdc253145a00069fe35ac7204f5437220e874d9b9df0e1eb31a63" => :mavericks
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
