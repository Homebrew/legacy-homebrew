require 'formula'

class Crfxx < Formula
  homepage 'http://code.google.com/p/crfpp/'
  url 'https://crfpp.googlecode.com/files/CRF++-0.58.tar.gz'
  sha1 '979a686a6d73d14cdd0c96a310888fb6bffd2e91'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end
end
