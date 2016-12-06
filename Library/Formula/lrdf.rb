require 'formula'

class Lrdf < Formula
  url 'http://sourceforge.net/projects/lrdf/files/liblrdf/0.4.0/liblrdf-0.4.0.tar.gz'
  homepage 'http://lrdf.sourceforge.net'
  md5 '327a5674f671c4b360c6353800226877'

  depends_on 'raptor'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
