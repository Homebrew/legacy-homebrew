class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.06.tar.gz"
  sha1 "2351408693aab0c6bc97d37e68b4a869fbb217ed"

  bottle do
    sha256 "7d514ce407dee1972abf23a51ff2acfe7d72bfde9854639bd6097bb39e6ab058" => :yosemite
    sha256 "1d83fa61da006086115e7d0b2e4ce04577c3812b10e553aa9b1b33b7d450f1de" => :mavericks
    sha256 "3d59f71840eac1512237bcda0668c38f51fff38d7a905011fcea2db94f7b5cda" => :mountain_lion
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
    sha1 "e9ebbb7675993a8d3bab6bf6403bbb2f31c14057"
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
