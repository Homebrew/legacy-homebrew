require 'formula'

class Libbinio < Formula
  url 'http://downloads.sourceforge.net/project/libbinio/libbinio/1.4/libbinio-1.4.tar.bz2'
  homepage 'http://libbinio.sf.net'
  md5 '517ded8c7ce9b3de0f84b1db74a2ebda'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
