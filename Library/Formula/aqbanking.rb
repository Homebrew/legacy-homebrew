require 'formula'

class Aqbanking < Formula
  homepage 'http://www.aqbanking.de/'
  head 'http://devel.aqbanking.de/svn/aqbanking/trunk'
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=118&file=01&dummy=aqbanking-5.5.1.tar.gz'
  sha1 '4783890253acf04dddede6d34bf81b8f1c24480d'

  depends_on 'gwenhywfar'
  depends_on 'libxmlsec1'
  depends_on 'libxslt'
  depends_on 'libxml2'
  depends_on 'gettext'
  depends_on 'gmp'
  depends_on 'pkg-config' => :build
  depends_on 'ktoblzcheck' => :recommended

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
