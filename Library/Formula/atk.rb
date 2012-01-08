require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.3/atk-2.3.3.tar.xz'
  sha256 '512b34c0787a41eebb43bc1150e92ca9addeeb78857d15df3e975e02375c3b07'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-dependency-tracking",
            "--enable-introspection=no"]
    system "./configure", *args
    system "make"
    system "make install"
  end
end
