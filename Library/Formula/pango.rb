require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.29/pango-1.29.3.tar.bz2'
  sha256 'a177f455f358a9b075e3b5d7e04891d90380c551e3ec28125e3d9aacca7dd43b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  if MacOS.leopard?
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-x"
    system "make install"
  end
end
