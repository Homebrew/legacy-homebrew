require 'formula'

class Lzma < Formula
  url 'http://tukaani.org/lzma/lzma-4.32.7.tar.bz2'
  homepage 'http://tukaani.org/lzma/'
  md5 '4828bc9e409cf1f084bc9f2799c49f3d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
