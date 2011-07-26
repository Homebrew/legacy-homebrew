require 'formula'

class Potrace < Formula
  url 'http://potrace.sourceforge.net/download/potrace-1.9.tar.gz'
  homepage 'http://potrace.sourceforge.net'
  md5 'ef973e7ec9c2e5b3e19e8dfeaa7524c3'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
