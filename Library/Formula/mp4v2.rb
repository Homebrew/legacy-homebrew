require 'formula'

class Mp4v2 <Formula
  url 'http://mp4v2.googlecode.com/files/mp4v2-1.9.1.tar.bz2'
  homepage 'http://code.google.com/p/mp4v2/'
  md5 '986701929ef15b03155ac4fb16444797'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
