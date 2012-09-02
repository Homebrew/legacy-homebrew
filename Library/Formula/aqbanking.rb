require 'formula'

class Aqbanking < Formula
  url 'http://www.aquamaniac.de/sites/download/download.php?package=03&release=94&file=01&dummy=aqbanking-5.0.24.0-git.tar.gz'
  homepage 'http://www.aqbanking.de/'
  sha1 '00577801882d63ba9ec7a7c900aae25af124586a'
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
