require 'formula'

class Gdb <Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.1.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 '21dce610476c054687b52770d2ddc657'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
