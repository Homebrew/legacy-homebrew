require 'formula'

class Libextractor < Formula
  url 'http://ftpmirror.gnu.org/libextractor/libextractor-0.6.2.tar.gz'
  homepage 'http://www.gnu.org/software/libextractor/'
  md5 '4b2af1167061430d58a101d5dfc6b4c7'

  depends_on 'libtool'
  depends_on 'glib'

  def install
    ENV.deparallelize

    system "./configure",
    "--prefix=#{prefix}",
    "--disable-ltdl-install",
    "--with-system-ltdl",
    "--with-ltdl-include=#{HOMEBREW_PREFIX}/include",
    "--with-ltdl-lib=#{HOMEBREW_PREFIX}/lib",
    "--disable-gtktest"

    #./configure --with-ltdl-include=/homebrew/include --with-ltdl-lib=/homebrew/lib --with-libiconv-prefix=/homerew --with-libintl-prefix=/homebrew --disable-xpdf --disable-gsf --disable-gnome

    system "make"
    system "make install"
  end

  def patches
    "https://gist.github.com/raw/956294/1a1e31416ba71ebaa07fec25bb64b259856fbc48/configure.diff"
  end
end
