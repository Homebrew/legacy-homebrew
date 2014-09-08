require 'formula'

class OpenVcdiff < Formula
  homepage 'http://code.google.com/p/open-vcdiff/'
  url 'https://open-vcdiff.googlecode.com/files/open-vcdiff-0.8.3.tar.gz'
  sha1 'fd14e8d46edac14988f1a6cab479bc07677d487c'

  def install
    system "./configure", "CPPFLAGS=-DGTEST_USE_OWN_TR1_TUPLE=1", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
