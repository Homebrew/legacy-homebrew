require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.3.58.tar.gz'
  sha1 '92b895e4da27a38e96d30f2958cca685716011ab'

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
