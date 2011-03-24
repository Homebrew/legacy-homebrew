require 'formula'

class Aqbanking < Formula
  url 'http://www.aquamaniac.de/sites/download/download.php?package=03&release=76&file=01&dummy=aqbanking-5.0.3.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 'a85e3e21a1cb04f0fe624299dc879d90'

  depends_on 'gettext'
  depends_on 'gmp'
  depends_on 'gwenhywfar'
  depends_on 'ktoblzcheck' => :optional

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
