require 'brewkit'

class PkgConfig <Formula
  @homepage='http://pkgconfig.freedesktop.org'
  @url='http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz'
  @md5='d922a88782b64441d06547632fd85744'

  #TODO depend on our glib if available. --with-installed-glib

  def install
    paths=%W[#{HOMEBREW_PREFIX}/lib/pkgconfig /usr/local/lib/pkgconfig /usr/lib/pkgconfig /usr/X11/lib/pkgconfig].uniq
    system "./configure", "--with-pc-path=#{paths*':'}", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end