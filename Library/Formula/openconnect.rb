class Openconnect < Formula
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.04.tar.gz"
  sha1 "1a87bebcc615fd96146a8afd05491883ef2b4daf"
  revision 1

  bottle do
    sha1 "8d039f7fc3d67f2d0054e063362b4ed1b07f8637" => :yosemite
    sha1 "59eebaa91254644babfbd79df555c2b5d60a2e1c" => :mavericks
    sha1 "63137e094db87867d88f3a69ed6d5d25d369b4a6" => :mountain_lion
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
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/df5808b301ba767578ffbec966db3b9ff154f588:/vpnc-script"
    sha1 "c4cb07222ed5b6c4a52f5c094dec9933ade87344"
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
