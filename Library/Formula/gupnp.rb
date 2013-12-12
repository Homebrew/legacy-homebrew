require 'formula'

class Gupnp < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gupnp/0.20/gupnp-0.20.8.tar.xz'
  sha256 'f70da127e0d35a7b8aecaf6f58b740bbb56836451be33d7aeb7979a5c131eac8'

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
