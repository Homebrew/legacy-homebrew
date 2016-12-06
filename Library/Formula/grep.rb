require 'formula'

class Grep <Formula
  url 'ftp://gnu.mirror.iweb.com/gnu/grep/grep-2.6.3.tar.gz'
  version '2.6.3'
  homepage 'http://www.gnu.org/software/grep/grep.html'
  md5 '3095b57837b312f087c0680559de7f13'

  depends_on 'libiconv'
  depends_on 'pcre'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"

    system "make install"
  end
end
