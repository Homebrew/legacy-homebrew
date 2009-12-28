require 'formula'

class Gwenhywfar <Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=01&release=29&file=01&dummy=gwenhywfar-3.11.1.tar.gz'
  homepage 'http://gwenhywfar.sourceforge.net/'
  md5 '0e339c07b5141caa616157061f78796d'

 depends_on 'pkg-config'
 depends_on 'gettext'
 depends_on 'gnutls'

  
  def install
    # llvm results in a sigsegfault during compile
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
