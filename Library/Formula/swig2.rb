require 'formula'

class Swig2 < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.2/swig-2.0.2.tar.gz'
  md5 'eaf619a4169886923e5f828349504a29'

  depends_on "pcre"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
