require 'formula'

class GsettingsDesktopSchemas < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.2/gsettings-desktop-schemas-3.2.0.tar.bz2'
  homepage 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/'
  sha256 '4a99260fddc4c9ae797c61d55d37e893b0c26261d86676a9f26b6b8ab5a99d3c'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
