require 'formula'

class Gdb < Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 '64260e6c56979ee750a01055f16091a5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
