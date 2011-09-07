require 'formula'

class Yconalyzer < Formula
  url 'http://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2'
  homepage 'http://sourceforge.net/projects/yconalyzer/'
  md5 '9b65a86d9c6aaf7717b9e2c7c1c4891e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "chmod +x ./install-sh"
    system "make install"
  end
end
