require 'formula'

class Aqbanking < Formula
  homepage 'http://www.aqbanking.de/'
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=95&file=01&dummy=aqbanking-5.0.25.tar.gz'
  sha1 '80314a6f6114a0a3f0062161bb38effc0f1f4b62'
  head 'http://devel.aqbanking.de/svn/aqbanking/trunk'

  devel do
    url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=103&file=01&dummy=aqbanking-5.1.0beta.tar.gz'
    sha1 'a628ddd93a58caee6e826e80829e98a85c14fc57'
  end

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
