require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.30/pango-1.30.1.tar.xz'
  sha256 '3a8c061e143c272ddcd5467b3567e970cfbb64d1d1600a8f8e62435556220cbe'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'

  depends_on 'fontconfig' if MacOS.leopard?

  # The Cairo library shipped with Lion contains a flaw that causes Graphviz
  # to segfault. See the following ticket for information:
  #   https://trac.macports.org/ticket/30370
  # We depend on our cairo on all platforms for consistency
  depends_on 'cairo'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-man",
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
