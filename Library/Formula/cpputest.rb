require 'formula'

class Cpputest < Formula
  homepage 'http://www.cpputest.org/'
  url 'hhttps://github.com/cpputest/cpputest/archive/v3.4.tar.gz'
  sha1 'ecd53f5b1a92a1f2291249ce69f544392f5a8462'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
