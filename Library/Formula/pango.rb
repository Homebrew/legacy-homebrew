require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/pango-1.30.0.tar.xz'
  sha256 '7c6d2ab024affaed0e942f9279b818235f9c6a36d9fc50688f48d387f4102dff'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

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

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.x11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-man",
                          "--with-x",
                          "--with-html-dir=#{share}/doc",
                          "--disable-introspection"
    system "make"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/pango-view", "-t", "test-image",
                                  "--waterfall", "--rotate=10",
                                  "--annotate=1", "--header",
                                  "-q", "-o", "output.png"
      system "/usr/bin/qlmanage", "-p", "output.png"
    end
  end
end
