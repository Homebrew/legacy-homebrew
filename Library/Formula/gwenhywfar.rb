require 'formula'

class Gwenhywfar <Formula
  url 'http://www.aquamaniac.de/sites/download/download.php?package=01&release=54&file=01&dummy=gwenhywfar-4.0.1.tar.gz'
  homepage 'http://gwenhywfar.sourceforge.net/'
  md5 '513ea7b5b22edf512fa7d825ef544954'

  depends_on 'pkg-config'
  depends_on 'gettext'
  depends_on 'gnutls'

  def install
    fails_with_llvm "llvm results in a sigsegfault during compile"
    system "./configure", "--prefix=#{prefix}", "--with-guis=''", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
