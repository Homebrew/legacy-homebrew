require 'formula'

class Gwenhywfar <Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=01&release=31&file=01&dummy=gwenhywfar-3.11.3.tar.gz'
  homepage 'http://gwenhywfar.sourceforge.net/'
  md5 '9ab62d881a0f39d4b07ea0badff7201f'

 depends_on 'pkg-config'
 depends_on 'gettext'
 depends_on 'gnutls'

  
  def install
    fails_with_llvm "llvm results in a sigsegfault during compile"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
