require 'formula'

class GsettingsDesktopSchemas < Formula
  homepage 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gsettings-desktop-schemas/3.5/gsettings-desktop-schemas-3.5.4.tar.xz'
  sha256 '0f5686683841a9d5a2d4e1dc60392d69cf2b2920614a5d504bb2cac5daea1df2'

  depends_on 'xz' => :build
  depends_on 'gettext'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

end
