require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.6/atk-2.6.0.tar.xz'
  sha256 'eff663f90847620bb68c9c2cbaaf7f45e2ff44163b9ab3f10d15be763680491f'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make"
    system "make install"
  end
end
