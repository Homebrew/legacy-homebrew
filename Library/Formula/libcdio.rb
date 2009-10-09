require 'brewkit'

class Libcdio <Formula
  url 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.81.tar.gz'
  md5 '2ad1622b672ccf53a3444a0c55724d38'
  homepage 'http://www.gnu.org/software/libcdio/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
