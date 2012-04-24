require 'formula'

class Gtksourceview < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz'
  md5 '220db5518e3f7fa06c980f057b22ba62'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
