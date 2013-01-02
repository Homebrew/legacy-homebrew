require 'formula'

class GsettingsDesktopSchemas < Formula
  homepage 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.5/gsettings-desktop-schemas-3.5.92.tar.xz'
  sha256 '65f6e866019d41599563774bbb4b08125760d4f93abcdf7704a8ee2fa9421b2e'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'glib' => :build # Yep, for glib-mkenums
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
