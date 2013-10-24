require 'formula'

class Gssdp < Formula
  homepage 'https://wiki.gnome.org/GUPnP/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gssdp/0.14/gssdp-0.14.3.tar.xz'
  sha256 '79dbdc5f79cc406632a783826b3dbe6acc0fbf41eb801b642bce1a02ecc3c66d'

  depends_on 'xz' => :build
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
