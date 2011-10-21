require 'formula'

class LibxdgBasedir < Formula
  url 'http://n.ethz.ch/~nevillm/download/libxdg-basedir/libxdg-basedir-1.1.1.tar.gz'
  homepage 'http://n.ethz.ch/~nevillm/download/libxdg-basedir/'
  md5 '7c64a28b08c8fdf6c8a95b0d5f1497b0'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
