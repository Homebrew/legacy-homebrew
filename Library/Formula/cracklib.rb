require 'formula'

class Cracklib < Formula
  homepage 'http://cracklib.sourceforge.net/'
  url 'http://sourceforge.net/projects/cracklib/files/cracklib/2.8.22/cracklib-2.8.22.tar.gz'
  sha1 'd91d977a1909e0cc3f5cb30754ba5e5e90655ab0'

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
