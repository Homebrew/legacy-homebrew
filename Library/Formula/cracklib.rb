require 'formula'

class Cracklib < Formula
  homepage 'http://cracklib.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cracklib/cracklib/2.9.0/cracklib-2.9.0.tar.gz'
  sha1 '827dcd24b14bf23911c34f4226b4453b24f949a3'

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
