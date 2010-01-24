require 'formula'

class Aqbanking <Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=47&file=01&dummy=aqbanking-4.2.1.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 'f017f85c6b5461383a584cf8e5ab41cf'

  depends_on 'gmp'
  depends_on 'gwenhywfar'
  depends_on 'ktoblzcheck' => :optional
  depends_on 'gettext'
 #depends_on 'qt3' # for gui frontends

  def install
    configure_args = [
        "--prefix=#{prefix}",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--with-frontends=cli",
    ]
    system "./configure", *configure_args
    ENV.j1
    system "make install"
  end
end
