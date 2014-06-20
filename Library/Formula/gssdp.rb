require 'formula'

class Gssdp < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gssdp/0.14/gssdp-0.14.8.tar.xz'
  sha256 '4c3ffa01435e84dc31c954e669e1ca0749b962f76a333e74f5c2cb0de5803a13'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'libsoup'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
