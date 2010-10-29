require 'formula'

class Pango <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.28/pango-1.28.1.tar.bz2'
  homepage 'http://www.pango.org/'
  sha256 '8f3eaab506f613dd25bb1fa65ea87a145d523d066d90c227bdb3016523451bc2'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  if MACOS_VERSION < 10.6
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  end

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"
    system "./configure", "--prefix=#{prefix}", "--with-x"
    system "make install"
  end
end
