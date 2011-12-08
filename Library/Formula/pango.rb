require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/pango/1.29/pango-1.29.4.tar.bz2'
  sha256 'f15deecaecf1e9dcb7db0e4947d12b5bcff112586434f8d30a5afd750747ff2b'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  if MacOS.leopard?
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  elsif MacOS.lion?
    depends_on 'cairo' # links against system Cairo without this
  end

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-man",
                          "--with-x",
                          "--with-html-dir=#{share}/doc"
    system "make"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/pango-view -t 'test-image' --waterfall --rotate=10 --annotate=1 --header -q -o output.png"
      system "/usr/bin/qlmanage -p output.png"
    end
  end
end
