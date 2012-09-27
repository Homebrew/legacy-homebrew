require 'formula'

class Conserver < Formula
  homepage 'http://conserver.com'
  url 'http://conserver.com/conserver-8.1.18.tar.gz'
  sha1 '54336e8ce7f48a2d8d51e93f4df492b3e426a192'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
