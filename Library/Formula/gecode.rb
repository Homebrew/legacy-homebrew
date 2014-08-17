require 'formula'

class Gecode < Formula
  homepage 'http://www.gecode.org/'
  url 'http://www.gecode.org/download/gecode-4.2.1.tar.gz'
  sha1 '41464bcb5bbbc62858ec6ae6b28a6d115343a040'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-examples"
    system "make install"
  end
end
