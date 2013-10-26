require 'formula'

class Flare < Formula
  homepage 'https://github.com/gree/flare/wiki'
  url 'https://github.com/gree/flare/archive/1.0.18.tar.gz'
  sha1 'ddbaaf4b2d887584533c5910fff4a1789b6f62d0'

  head 'https://github.com/fujimoto/flare.git'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'tokyo-cabinet'
  depends_on 'boost'

  def install
    system "autoreconf -vfi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
