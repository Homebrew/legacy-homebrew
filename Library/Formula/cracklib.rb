require 'formula'

class Cracklib < Formula
  homepage 'http://cracklib.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cracklib/cracklib/2.8.19/cracklib-2.8.19.tar.gz'
  sha1 '29224f51db85e1946c209f6ef6c38da699a9c7cc'

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
