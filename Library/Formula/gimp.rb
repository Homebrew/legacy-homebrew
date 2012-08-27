require 'formula'

class Gimp < Formula
  homepage 'http://www.gimp.org/'
  url 'ftp://ftp.gimp.org/pub/gimp/v2.8/gimp-2.8.2.tar.bz2'
  sha1 '64ad90cedc5e8e348310b6eb6b7821ec110c0886'

  depends_on :x11
  depends_on 'atk'
  depends_on 'gtk+'
  depends_on 'babl'
  depends_on 'gegl'
  depends_on 'glib'
  depends_on 'pango'
  depends_on 'cairo'
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gdk-pixbuf'

  depends_on 'dbus-glib' => :optional

  depends_on 'libart' => :optional
  depends_on 'hicolor-icon-theme' => :optional

  depends_on 'pkg-config' => :build

  def install
    ENV['PKG_CONFIG_PATH'] = '/usr/X11/lib/pkgconfig/'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mp",
                          "--with-pdbgen",
                          "--with-x",
                          "--x-includes=/usr/X11R6/include",
                          "--x-libraries=/usr/X11R6/lib",
                          "--without-alsa",
                          "--without-gvfs",
                          "--without-webkit",
                          "--disable-python"

    system "make install"

    # Let's optimze the Gimp icons loading if gtk-update-icon-cache is installed.
    gtk_update_icon_cache_path = "#{HOMEBREW_PREFIX}/bin/gtk-update-icon-cache"
    system "test -x #{gtk_update_icon_cache_path} && #{gtk_update_icon_cache_path} -f -t #{HOMEBREW_PREFIX}/share/icons/hicolor || ! test -x #{gtk_update_icon_cache_path}"
  end

  def test
    system "gimp"
  end
end
