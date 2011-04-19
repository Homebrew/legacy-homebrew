require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.28/pango-1.28.4.tar.bz2'
  sha256 '7eb035bcc10dd01569a214d5e2bc3437de95d9ac1cfa9f50035a687c45f05a9f'

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
