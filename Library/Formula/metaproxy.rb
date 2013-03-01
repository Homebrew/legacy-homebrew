require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.3.53.tar.gz'
  sha1 '67cd120bc6be15d3987e4867d7a5e598c0c58680'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost149'

  def install
    old_boost = Formula.factory("boost149")
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{old_boost.prefix}"
    system "make install"
  end
end
