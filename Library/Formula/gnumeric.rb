require 'formula'

class Gnumeric < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gnumeric/1.10/gnumeric-1.10.16.tar.bz2'
  homepage 'http://projects.gnome.org/gnumeric/'
  sha256 '600787c6b2646e1bec78b36b7665bacd9d48fd99d21deae310002e11a82bbc86'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'goffice'
  depends_on 'rarian'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
