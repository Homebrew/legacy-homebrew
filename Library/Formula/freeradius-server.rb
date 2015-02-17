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
    url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.6.tar.bz2"
    sha1 "37c5a38f74a8b228abe9682db9f3184a9c7d9639"
    depends_on "talloc" => :build
  end

  bottle do
    sha1 "3a583d46e2c12badc7addf99fa1db83a8d5315b4" => :yosemite
    sha1 "ee905079281616a48339201938d11fe525d8b23f" => :mavericks
    sha1 "2e8de634e8fcf37a2a4d969d33371281667e5d2d" => :mountain_lion
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
