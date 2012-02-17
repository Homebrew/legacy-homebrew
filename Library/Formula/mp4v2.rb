require 'formula'

class Mp4v2 < Formula
  url 'http://mp4v2.googlecode.com/files/mp4v2-trunk-r479.tar.bz2'
  homepage 'http://code.google.com/p/mp4v2/'
  md5 '9ffd774fa88ad993e28236551511850b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
