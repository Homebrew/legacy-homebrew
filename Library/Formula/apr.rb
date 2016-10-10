require 'formula'

class Apr < Formula
  url 'http://apache.cs.utah.edu/apr/apr-1.4.2.tar.gz'
  homepage 'http://apr.apache.org/'
  md5 'fc80cb54f158c2674f9eeb47a1f672cd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
