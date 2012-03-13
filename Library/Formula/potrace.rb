require 'formula'

class Potrace < Formula
  url 'http://potrace.sourceforge.net/download/potrace-1.10.tar.gz'
  homepage 'http://potrace.sourceforge.net'
  md5 'c6a7227ed0a6291a95f38c7d4352ba53'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
