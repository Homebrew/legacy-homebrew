require 'formula'

class SwfdecGnome <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/swfdec-gnome/2.30/swfdec-gnome-2.30.1.tar.gz'
  homepage 'http://swfdec.freedesktop.org/#Swfdec-Gnome'
  md5 '4b8bf130cb0459d2b27f5c2dbfd25d5e'

  depends_on 'swfdec'
  depends_on 'gconf'
  depends_on 'intltool'

  def install
    gettext_bins = Formula.factory('gettext').bin
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "XGETTEXT=#{gettext_bins}/xgettext",
                          "MSGMERGE=#{gettext_bins}/msgmerge",
                          "MSGFMT=#{gettext_bins}/msgfmt" #,
                          #"GMSGFMT=#{gettext_bins}/gmsgfmt"
    system "make install"
  end
end
