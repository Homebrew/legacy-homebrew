require 'formula'

class Fuego < Formula
  url 'http://downloads.sourceforge.net/project/fuego/fuego/1.0/fuego-1.0.tar.gz'
  homepage 'http://fuego.sourceforge.net/'
  md5 'ad9d0f6bb5ac00f71468bd592ab772f4'

  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
