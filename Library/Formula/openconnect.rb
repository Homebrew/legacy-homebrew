class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.06.tar.gz"
  sha256 "facf695368dc4537a6a30e2147be90b1d77ee3cb2d269eaef070b6d9ddab70f2"
  revision 1

  bottle do
    sha256 "2ef2b744defa276e570e26670f0b68e4fa5082930120f72e2fc7df53ab0e8c21" => :el_capitan
    sha256 "de85876d8ab21f85179117585c273d7fffa471532fea24f2b7080998175f3840" => :yosemite
    sha256 "eeabad2f02c28d233fef47235e9518a293bc93eb911594936976fbd5181a5305" => :mavericks
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # No longer compiles against OpenSSL 1.0.2 - It chooses the system OpenSSL instead.
  # http://lists.infradead.org/pipermail/openconnect-devel/2015-February/002757.html

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "oath-toolkit" => :optional
  depends_on "stoken" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/a64e23b1b6602095f73c4ff7fdb34cccf7149fd5:/vpnc-script"
    sha256 "cc30b74788ca76928f23cc7bc6532425df8ea3701ace1454d38174ca87d4b9c5"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match /AnyConnect VPN/, pipe_output("#{bin}/openconnect 2>&1")
  end
end
