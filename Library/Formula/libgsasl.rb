require 'formula'

class Libgsasl <Formula
  url 'ftp://ftp.gnu.org/gnu/gsasl/libgsasl-1.4.4.tar.gz'
  homepage 'http://www.gnu.org/software/gsasl/'
  md5 '2ca9cd8c0158692b141cb14ba1045d7b'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
