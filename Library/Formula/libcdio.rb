require 'formula'

class Libcdio <Formula
  url 'http://ftp.gnu.org/gnu/libcdio/libcdio-0.81.tar.gz'
  md5 '2ad1622b672ccf53a3444a0c55724d38'
  homepage 'http://www.gnu.org/software/libcdio/'

  depends_on 'libiconv'

  def install
    ENV.append 'LDFLAGS', "-L/usr/local/lib"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking" "--with-libiconv-prefix"
    system "make install"
  end
end
