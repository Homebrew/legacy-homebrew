require 'formula'

class Wsmancli < Formula
  homepage 'https://github.com/Openwsman/wsmancli'
  url 'https://github.com/Openwsman/wsmancli/archive/v2.3.0.tar.gz'
  sha1 '161288cbc4f5a60a2d683d96ead3a0934a9c5523'

  depends_on "openwsman"
  depends_on "autoconf"   => :build
  depends_on "automake"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "wsman --help"
  end
end
