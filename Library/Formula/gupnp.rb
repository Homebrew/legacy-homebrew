require 'formula'

class Gupnp < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gupnp/0.20/gupnp-0.20.3.tar.xz'
  sha256 'ed7db7506506434d0fd272e3866d7ae985af5b9d7e9e5e120f8581ade90869f0'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libsoup'
  depends_on 'gssdp'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
