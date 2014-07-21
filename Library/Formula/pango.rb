require 'formula'

class Pango < Formula
  homepage "http://www.pango.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/pango/1.36/pango-1.36.5.tar.xz"
  sha256 "be0e94b2e5c7459f0b6db21efab6253556c8f443837200b8736d697071276ac8"

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

    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/pango-querymodules", "--version"
  end
end
