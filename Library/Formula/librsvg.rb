require 'formula'

class Librsvg < Formula
  homepage 'https://live.gnome.org/LibRsvg'
  url 'http://ftp.gnome.org/pub/GNOME/sources/librsvg/2.36/librsvg-2.36.3.tar.xz'
  sha256 '3d7d583271030e21acacc60cb6b81ee305713c9da5e98429cbd609312aea3632'

  bottle do
    cellar :any
    revision 1
    sha1 "4e83e5f0691db664289df16b3c491618d400b12c" => :yosemite
    sha1 "e08617797236e3cffc78adaca0c254af7cfb4d50" => :mavericks
    sha1 "7b20f7d74b54ad6c03fd290ccd4ebb3707b00a89" => :mountain_lion
  end

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libcroco'
  depends_on 'libgsf' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-Bsymbolic",
            "--enable-tools=yes",
            "--enable-pixbuf-loader=yes",
            "--enable-introspection=no"]

    args << "--enable-svgz" if build.with? 'libgsf'

    system "./configure", *args
    system "make install"
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end
end
