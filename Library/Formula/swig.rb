require 'brewkit'

class Swig <Formula
  url 'http://downloads.sourceforge.net/swig/swig-1.3.40.tar.gz'
  homepage 'http://www.swig.org/'
  md5 '2df766c9e03e02811b1ab4bba1c7b9cc'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
