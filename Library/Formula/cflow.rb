require 'formula'

class Cflow < Formula
  url 'http://ftpmirror.gnu.org/cflow/cflow-1.4.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/cflow/cflow-1.4.tar.bz2'
  homepage 'http://www.gnu.org/software/cflow/'
  md5 '3d1bb6ae5cb6c31311b5fcead625dd57'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make install"
  end
end
