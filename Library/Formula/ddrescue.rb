require 'formula'

class Ddrescue < Formula
  homepage 'http://www.gnu.org/software/ddrescue/ddrescue.html'
  url 'http://ftpmirror.gnu.org/ddrescue/ddrescue-1.16.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.16.tar.gz'
  sha1 '293e12624383e2890800a11fcc267559c85b3259'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make install"
  end
end
