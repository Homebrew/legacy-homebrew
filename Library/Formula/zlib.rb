require 'formula'

class Zlib < Formula
  homepage 'http://zlib.net/'
  url 'http://zlib.net/zlib-1.2.5.tar.gz'
  version '1.2.5'
  md5 'c735eab2d659a96e5a594c9e8541ad63'

  def install
    system "./configure"
    system "make"
    system "sudo make install"
  end
end
