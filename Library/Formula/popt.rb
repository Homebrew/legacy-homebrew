require 'formula'

class Popt < Formula
  url 'http://rpm5.org/files/popt/popt-1.16.tar.gz'
  homepage 'http://rpm5.org'
  md5 '3743beefa3dd6247a73f8f7a32c14c33'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
