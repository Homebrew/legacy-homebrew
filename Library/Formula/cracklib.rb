require 'formula'

class Cracklib < Formula
  url 'http://downloads.sourceforge.net/project/cracklib/cracklib/2.8.16/cracklib-2.8.16.tar.gz'
  homepage 'http://cracklib.sourceforge.net/'
  md5 '3bfb22db8fcffd019463ee415a1b25b7'

  depends_on "gettext"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-default-dict=#{HOMEBREW_PREFIX}/share/cracklib-words"
    system "make install"
  end
end
