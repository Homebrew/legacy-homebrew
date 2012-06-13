require 'formula'

class Beecrypt < Formula
  url 'http://sourceforge.net/projects/beecrypt/files/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz'
  homepage 'http://beecrypt.sourceforge.net'
  sha256 '286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d'

  depends_on "icu4c"

  def install
    ENV.remove_from_cflags /-march=\S*/
    system "./configure", "--prefix=#{prefix}", "--disable-openmp", "--without-java", "--without-python"
    system "make"
    system "make check"
    system "make install"
  end
end
