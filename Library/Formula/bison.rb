require 'formula'

class Bison <Formula
  url 'http://ftp.gnu.org/gnu/bison/bison-2.4.tar.gz'
  homepage 'http://www.gnu.org/software/bison/bison.html'
  md5 '2b9b088b46271c7fa902a7e85f503e1e'

  depends_on 'libiconv'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-libiconv-prefix=#{HOMEBREW_PREFIX}/"

    system "make install"
  end
end
