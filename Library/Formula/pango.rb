require 'formula'

class Pango < Formula
  homepage "http://www.pango.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/pango/1.36/pango-1.36.6.tar.xz"
  sha256 "4c53c752823723875078b91340f32136aadb99e91c0f6483f024f978a02c8624"

  head do
    url 'git://git.gnome.org/pango'

    depends_on 'automake' => :build
    depends_on 'autoconf' => :build
    depends_on 'libtool' => :build
    depends_on 'gtk-doc' => :build
  end

  bottle do
    sha1 "cae579ffdc52ad681a23d5af611818c9af873e67" => :mavericks
    sha1 "473cd6a06a42e4d3e6bc24779b2094e771b16560" => :mountain_lion
    sha1 "73880906087275dcd394f0567136898bbf2dca94" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'harfbuzz'
  depends_on 'fontconfig'
  depends_on :x11 => :recommended
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

    if build.without? "x11"
      args << '--without-xft'
    else
      args << '--with-xft'
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/pango-querymodules", "--version"
  end
end
