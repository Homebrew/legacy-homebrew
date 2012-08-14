require 'formula'

class Gdbm < Formula
  homepage 'http://www.gnu.org/software/gdbm/'
  url 'http://ftpmirror.gnu.org/gdbm/gdbm-1.10.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gdbm/gdbm-1.10.tar.gz'
  md5 '88770493c2559dc80b561293e39d3570'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
