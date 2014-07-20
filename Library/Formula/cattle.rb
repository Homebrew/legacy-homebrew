require 'formula'

class Cattle < Formula
  homepage 'https://github.com/andreabolognani/cattle#readme'
  url 'https://github.com/andreabolognani/cattle/archive/cattle-1.0.1.tar.gz'
  sha1 '1c60cdf8dc6b2b27bd4dfb79adea905a22e033c2'

  depends_on 'glib'
  depends_on 'gobject-introspection'
  depends_on 'gtk-doc' => :build
  depends_on 'pkg-config' => :build

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'

    system 'sh autogen.sh'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
