require 'formula'

class GnomeIconTheme < Formula
  homepage 'https://developer.gnome.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gnome-icon-theme/3.10/gnome-icon-theme-3.10.0.tar.xz'
  sha256 'c65472b5846c67b97fe75200c5180faccd1347a04caa8390fc0ad23de75b36f6'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+' # we require gtk-update-icon-cache
  depends_on 'icon-naming-utils'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
