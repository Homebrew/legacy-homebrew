require "formula"

class Openconnect < Formula
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-6.00.tar.gz"
  sha1 "405f0563a82660fa492d8c9ad248198adb8793f9"

  bottle do
    sha1 "abff92f7f22f41eb8b28465819009907a243099b" => :mavericks
    sha1 "3953bb2cad981dda52a3cac1bbb81331f8c2ff5c" => :mountain_lion
    sha1 "6594e0676a47a8b416388da8508780f251992ab8" => :lion
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
