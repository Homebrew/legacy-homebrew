require "formula"

class Openconnect < Formula
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.04.tar.gz"
  sha1 "1a87bebcc615fd96146a8afd05491883ef2b4daf"

  bottle do
    sha1 "304af06c460efee55cffd2086ca1a7b3a36ae6f7" => :yosemite
    sha1 "5a151e79eff6550a7832aa9493d67e7194ce78b5" => :mavericks
    sha1 "43a8ec2383668d00d1fbc4734c3d3de3069c264f" => :mountain_lion
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
  depends_on "stoken" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/df5808b301ba767578ffbec966db3b9ff154f588:/vpnc-script"
    sha1 "c4cb07222ed5b6c4a52f5c094dec9933ade87344"
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
end
