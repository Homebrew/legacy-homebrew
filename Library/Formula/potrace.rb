require 'formula'

class Potrace <Formula
  url 'http://potrace.sourceforge.net/download/potrace-1.8.tar.gz'
  homepage 'http://potrace.sourceforge.net'
  md5 'e73b45565737d64011612704dd4d9f86'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
