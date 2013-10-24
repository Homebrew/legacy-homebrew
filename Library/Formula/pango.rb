require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.36/pango-1.36.0.tar.xz'
  sha256 'bb41d1b26ee7450e5430a7d2765f38c51ebe72db9fce616a9ee52611b55906a0'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'harfbuzz'
  depends_on 'fontconfig'
  depends_on :x11 unless build.without? 'x'
  depends_on 'gobject-introspection'

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
      --enable-introspection=yes
    ]

    if build.include? 'without-x'
      args << '--without-xft'
    else
      args << '--with-xft'
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pango-querymodules", "--version"
  end
end
