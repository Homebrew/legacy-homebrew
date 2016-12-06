require 'formula'

class Swig1 < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-1.3.40/swig-1.3.40.tar.gz'
  md5 '2df766c9e03e02811b1ab4bba1c7b9cc'

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end

