require 'formula'

class Cflow < Formula
  homepage 'http://www.gnu.org/software/cflow/'
  url 'http://ftpmirror.gnu.org/cflow/cflow-1.4.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/cflow/cflow-1.4.tar.bz2'
  sha1 'b8c3674e47112d5a81c34719fef343430be77f88'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"
  end
end
