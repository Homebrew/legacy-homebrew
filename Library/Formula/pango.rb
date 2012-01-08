require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/pango/1.29/pango-1.29.5.tar.bz2'
  sha256 '2fc74dcb162dd471198be2e68b12ce7528fe059ce6cdd79bbb529ee58a39e136'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  if MacOS.leopard?
    depends_on 'fontconfig' # Leopard's fontconfig is too old.
    depends_on 'cairo' # Leopard doesn't come with Cairo.
  elsif MacOS.lion?
    # The Cairo library shipped with Lion contains a flaw that causes Graphviz
    # to segfault. See the following ticket for information:
    #
    #   https://trac.macports.org/ticket/30370
    depends_on 'cairo'
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
