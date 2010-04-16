require 'formula'

class Libtool <Formula
  url 'http://ftp.gnu.org/gnu/libtool/libtool-2.2.6b.tar.gz'
  homepage 'http://www.gnu.org/software/libtool/'
  md5 '07da460450490148c6d2df0f21481a25'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
