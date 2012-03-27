require 'formula'

class Colpack < Formula
  url 'http://www.cscapes.org/download/ColPack/ColPack-1.0.6.tar.gz'
  homepage 'http://www.cscapes.org/coloringpage/software.htm'
  md5 'bee15e629c63ba85ea3f987ea40bc795'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool'  => :build

  def install
    system "autoreconf -fi"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
