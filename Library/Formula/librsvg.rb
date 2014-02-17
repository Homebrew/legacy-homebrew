require 'formula'

class Librsvg < Formula
  homepage 'https://live.gnome.org/LibRsvg'
  url 'http://mirror.umd.edu/gnome/sources/librsvg/2.40/librsvg-2.40.1.tar.xz'
  sha256 '8813b4fe776d5e7acbce28bacbaed30ccb0cec3734eb3632c711a16ebe2961d7'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
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
end
