require 'formula'

class Gtksourceview < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceview/2.11/gtksourceview-2.11.2.tar.bz2'
  homepage 'http://projects.gnome.org/gtksourceview/'
  sha256 'f9594d8f18f6bcc3d72da4051636d7a8b4d3f6d29d6827309b262c9483644994'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
  
  def patches
  # fixes deprecated constants
  "https://raw.github.com/gist/1491725/5f86e4d4e2245f01876ada1023d55e0366abd5dc/gtksourceview-const.patch"
  end
end
