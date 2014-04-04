require 'formula'

class GsettingsDesktopSchemas < Formula
  homepage 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.10/gsettings-desktop-schemas-3.10.1.tar.xz'
  sha256 '452378c4960a145747ec69f8c6a874e5b7715454df3e2452d1ff1a0a82e76811'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib' => :build # Yep, for glib-mkenums
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make install"
  end

end
