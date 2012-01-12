require 'formula'

class Libdca < Formula
  url 'http://download.videolan.org/pub/videolan/libdca/0.0.5/libdca-0.0.5.tar.bz2'
  homepage 'http://www.videolan.org/developers/libdca.html'
  md5 'dab6b2795c66a82a6fcd4f8343343021'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
