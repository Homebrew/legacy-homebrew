require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.36/pango-1.36.2.tar.xz'
  sha256 'f07f9392c9cf20daf5c17a210b2c3f3823d517e1917b72f20bb19353b2bc2c63'

  bottle do
    sha1 "58eb78b432c1a6e99d3ef2c6171118c8cce3d569" => :mavericks
    sha1 "0887ad9879ef06cbcebffb0298957d281cc4b83a" => :mountain_lion
    sha1 "8cd38f8356eb11db8863555891be34d422f5f7dd" => :lion
  end

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
      --disable-silent-rules
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
