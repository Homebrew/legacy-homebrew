require 'formula'

class Surfraw <Formula
  url 'http://surfraw.alioth.debian.org/dist/surfraw-2.2.7.tar.gz'
  homepage 'http://surfraw.alioth.debian.org/'
  md5 '213010e9b7c8478827e8903530cf7787'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # Install using 1 job, or fails on Mac Pro
    system "make install"
  end
end
