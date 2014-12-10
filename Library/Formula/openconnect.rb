require "formula"

class Openconnect < Formula
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.01.tar.gz"
  sha1 "69edfa8d4af93ef33e90b21f25f2949d1997c83a"

  bottle do
    sha1 "4b2a69e83336d0817e7a5e3a1a3360be6caadeb2" => :yosemite
    sha1 "a2149452cb673b6e16042bc607a80369fde91589" => :mavericks
    sha1 "b59dc9fdf8b070bd897b1d879b791635cb0d1dd7" => :mountain_lion
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
