require 'formula'

class Zsync < Formula
  url 'http://zsync.moria.org.uk/download/zsync-0.6.1.tar.bz2'
  homepage 'http://zsync.moria.org.uk/'
  md5 'cab880e6cb3a5b0976b0930a5b6e3256'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
