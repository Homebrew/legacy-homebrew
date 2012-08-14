require 'formula'

class Fribidi < Formula
  url 'http://fribidi.org/download/fribidi-0.19.2.tar.gz'
  md5 '626db17d2d99b43615ad9d12500f568a'
  homepage 'http://fribidi.org/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
