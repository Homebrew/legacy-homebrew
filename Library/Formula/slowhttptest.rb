require 'formula'

class Slowhttptest < Formula
  homepage 'http://code.google.com/p/slowhttptest/'
  url 'http://slowhttptest.googlecode.com/files/slowhttptest-1.4.tar.gz'
  sha1 '651305c76255477f81377646d9298a1528c75d77'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "slowhttptest -h | grep 'slowhttptest #{version}'"
  end
end
