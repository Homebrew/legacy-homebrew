require 'formula'

class Stormfs < Formula
  homepage 'https://github.com/benlemasurier/stormfs'
  url 'https://github.com/benlemasurier/stormfs/archive/v0.03.tar.gz'
  sha1 'bae7aeb409b910dd3844cd930f3ad9427d7e1609'

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glib"
  depends_on "fuse4x"
  depends_on "curl" if MacOS.version <= :leopard

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
