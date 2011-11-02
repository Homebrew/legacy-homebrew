require 'formula'

class Fribidi < Formula
  url 'http://fribidi.org/download/fribidi-0.19.2.tar.gz'
  homepage 'http://fribidi.org/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
