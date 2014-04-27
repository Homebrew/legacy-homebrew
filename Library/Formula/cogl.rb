require 'formula'

class Cogl < Formula
  homepage 'http://developer.gnome.org/cogl/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/cogl/1.18/cogl-1.18.0.tar.xz'
  sha256 'a4d91ebf7e7aba362eb5c6e4ffebbf1167ff4ac87fabae104912d879a5390f5e'

  head do
    url "git://git.gnome.org/cogl"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'cairo'
  depends_on 'glib'
  depends_on 'pango'

  def install
    system "./autogen.sh" if build.head?
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --disable-introspection
      --disable-glx
      --without-x
    ]

    system './configure', *args
    system "make install"
  end
end
