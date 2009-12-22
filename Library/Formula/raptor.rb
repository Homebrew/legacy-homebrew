require 'formula'

class Raptor <Formula
  url 'http://download.librdf.org/source/raptor-1.4.20.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '4d9c950ea794d3e141ff60875b0a2bbc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
