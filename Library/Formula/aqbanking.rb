require 'formula'

class Aqbanking < Formula
  url 'http://www.aquamaniac.de/sites/download/download.php?package=03&release=78&file=01&dummy=aqbanking-5.0.10.tar.gz'
  homepage 'http://www.aqbanking.de/'
  md5 'b50c28887fc9fd2fc9a4d9fc996497e6'
  head 'http://devel.aqbanking.de/svn/aqbanking/trunk'

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
