require 'formula'

class GlibNetworking < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.30/glib-networking-2.30.1.tar.bz2'
  homepage 'https://launchpad.net/glib-networking'
  sha256 '81570b3131ca06e50b0bd01947baf3eb86023e399c5adb35515315d23b66f545'

  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'gsettings-desktop-schemas'

  def install
    ENV.append "CPPFLAGS", "-I/usr/local/Cellar/gsettings-desktop-schemas/3.2.0/include/gsettings-desktop-schemas/"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--without-ca-certificates", "--prefix=#{prefix}"
    system "make install"
  end
end