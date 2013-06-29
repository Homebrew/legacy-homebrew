require 'formula'

class Libdca < Formula
  homepage 'http://www.videolan.org/developers/libdca.html'
  url 'http://download.videolan.org/pub/videolan/libdca/0.0.5/libdca-0.0.5.tar.bz2'
  sha1 '3fa5188eaaa2fc83fb9c4196f6695a23cb17f3bc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
