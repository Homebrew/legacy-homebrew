require 'formula'

class Gtksourceview < Formula
  homepage 'http://projects.gnome.org/gtksourceview/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceview/2.10/gtksourceview-2.10.5.tar.gz'
  sha1 '1bb784d1e9d9966232928cf91b1ded20e8339670'

  depends_on :x11
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
