require 'formula'

class Gecode < Formula
  url 'http://www.gecode.org/download/gecode-3.7.0.tar.gz'
  homepage 'http://www.gecode.org/'
  md5 '17401d48da79dc4423191c1c0adfd7d0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
