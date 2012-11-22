require 'formula'

class Arowxx < Formula
  homepage 'http://code.google.com/p/arowpp/'
  url 'http://arowpp.googlecode.com/files/AROW%2B%2B-0.1.2.tar.gz'
  sha1 '82d3a25ea30db1b3b412a0ba723f6196ebb69d52'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
