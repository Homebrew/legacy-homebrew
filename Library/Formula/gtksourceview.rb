require 'formula'

class Gtksourceview <Formula
  url 'http://ftp.acc.umu.se/pub/gnome/sources/gtksourceview/2.11/gtksourceview-2.11.2.tar.bz2'
  homepage 'http://http://projects.gnome.org/gtksourceview/'
  md5 '2a39aecb212e1bd3a3a0e5a3eca32623'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
