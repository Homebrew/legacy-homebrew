require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.32/pango-1.32.2.tar.xz'
  sha256 '23124e01a7795374a6c2864b69ee49064de31b84b3776924461c0b8b42e8e5cb'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on :x11 unless build.include? 'without-x'

  if MacOS.version == :leopard
    depends_on 'fontconfig'
  else
    depends_on :fontconfig
  end

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
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --disable-introspection
    ]

    if build.include? 'without-x'
      args << '--without-x'
    else
      args << '--with-x'
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    mktemp do
      system "#{bin}/pango-view", "-t", "test-image",
                                  "--waterfall", "--rotate=10",
                                  "--annotate=1", "--header"
    end
  end
end
