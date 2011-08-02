require 'formula'

class Aescrypt < Formula
  url 'http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz'
  homepage 'http://aescrypt.sourceforge.net/'
  md5 'cbec5d7f00a289944397a8079c1d3c6c'

  def install
    system "./configure"
    system "make"
    bin.install ['aescrypt', 'aesget']
  end
end
