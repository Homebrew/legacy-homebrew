require 'formula'

class Libredwg < Formula
  head 'git://git.sv.gnu.org/libredwg.git'
  homepage 'http://www.gnu.org/software/libredwg/'

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make install"
  end
end
