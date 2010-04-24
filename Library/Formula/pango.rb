require 'formula'

class Pango <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.28/pango-1.28.0.tar.bz2'
  homepage 'http://www.pango.org/'
  sha256 '68480485b714e3570a58c270add9e9785fa78068f7410949b478e8a9d3f5bc40'

  depends_on 'pkg-config'
  depends_on 'glib'

  if MACOS_VERSION < 10.6
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-x"
    system "make install"
  end
end
