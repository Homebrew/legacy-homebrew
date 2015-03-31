class FreeradiusServer < Formula
  homepage "http://freeradius.org/"
  revision 2

  stable do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-2.2.6.tar.gz"
    sha1 "25b0a057b1fffad5a030946e8af0c6170e5cdf46"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  devel do
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.7.tar.bz2"
    sha1 "d3fda2c4baa79fa72942fc77a33aa30e308d31a9"
    depends_on "talloc" => :build
  end

  bottle do
    sha1 "a46ed359e5124ea50fe3331d150a7ad82011e1b5" => :yosemite
    sha1 "e9ddff066dd51b5cbc207787a3f5d3053e8ce088" => :mavericks
    sha1 "9406f32f9e73f44383b0cdc8410ea79b5504c95f" => :mountain_lion
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
