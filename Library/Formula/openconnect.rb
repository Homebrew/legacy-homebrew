require "formula"

class Openconnect < Formula
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-6.00.tar.gz"
  sha1 "405f0563a82660fa492d8c9ad248198adb8793f9"
  revision 1

  bottle do
    revision 1
    sha1 "8f824c3d71fe5879335275225922158b5da4076f" => :mavericks
    sha1 "60947b9e8cada4dc82135499afa92c68ef65f849" => :mountain_lion
    sha1 "4afb9be94d8288c1c1ac729a2abc421ccfb7dc7a" => :lion
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-gnutls", "Use GnuTLS instead of OpenSSL"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl" if build.without? "gnutls"
  depends_on "gnutls" => :optional
  depends_on "oath-toolkit" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/a78b3ddfc56ab457104c88e94dca72d8738f4fad:/vpnc-script"
    sha1 "9516b6e303392cfb5518de3f44767f226c690a1c"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["GIT_DIR"] = cached_download/".git"
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
    system "make install"
  end

  def caveats; <<-EOS.undent
    OpenConnect requires the use of a TUN/TAP driver.

    You can download one at http://tuntaposx.sourceforge.net/
    and install it prior to running OpenConnect.
    EOS
  end
end
