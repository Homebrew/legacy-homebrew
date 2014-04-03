require 'formula'

class Gtkglarea < Formula
  homepage 'https://github.com/GNOME/gtkglarea'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtkglarea/2.0/gtkglarea-2.0.1.tar.gz'
  sha1 'db12f2bb9a3d28d69834832e2e04a255acfd8a6d'

  depends_on :x11
  depends_on 'gtk+'
  depends_on 'pkg-config' => :build

  def install
    ENV.append 'LDFLAGS', '-lX11'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
