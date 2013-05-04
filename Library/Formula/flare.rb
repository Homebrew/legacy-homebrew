require 'formula'

class Flare < Formula
  homepage 'http://labs.gree.jp/Top/OpenSource/Flare-en.html'
  url 'http://labs.gree.jp/data/source/flare-1.0.16.1.tgz'
  sha1 'b1103b25249737b742b436639c8241f0b9801b70'

  head 'https://github.com/fujimoto/flare.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'tokyo-cabinet'
  depends_on 'boost'

  def install
    # Compatibility with Automake 1.13 and newer.
    inreplace 'configure.ac', 'AM_CONFIG_HEADER', 'AC_CONFIG_HEADERS'
    system "autoreconf -vfi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
