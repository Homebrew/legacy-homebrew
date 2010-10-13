require 'formula'

class Aqbanking <Formula
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=74&file=01&dummy=aqbanking-5.0.1.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 'dc7dd799a4a50313b5f11b9a0861b72b'

  depends_on 'gettext'
  depends_on 'gmp'
  depends_on 'gwenhywfar'
  depends_on 'ktoblzcheck' => :optional

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-frontends=cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
