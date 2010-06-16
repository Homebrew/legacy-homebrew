require 'formula'

class Aqbanking <Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=50&file=01&dummy=aqbanking-4.2.4.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 '244f5c6e470b55452d9f2cb6c081c137'

  depends_on 'gmp'
  depends_on 'gwenhywfar'
  depends_on 'ktoblzcheck' => :optional
  depends_on 'gettext'
 #depends_on 'qt3' # for gui frontends

  def install
    fails_with_llvm "llvm results in a sigsegfault during compile"
    configure_args = [
        "--prefix=#{prefix}",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--with-frontends=cli",
        "--with-gwen-dir=#{HOMEBREW_PREFIX}",
    ]
    system "./configure", *configure_args
    ENV.j1
    system "make install"
  end
end
