require 'formula'

class Swig <Formula
  url 'http://downloads.sourceforge.net/swig/swig-2.0.0.tar.gz'
  homepage 'http://www.swig.org/'
  md5 '36ee2d9974be46a9f0a36460af928eb9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
