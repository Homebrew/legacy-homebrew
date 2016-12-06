require 'formula'

class Goffice < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/goffice/0.8/goffice-0.8.16.tar.bz2'
  homepage 'http://projects.gnome.org/gnumeric/'
  sha256 '511280a7c8fcefd1ce7be17bbe134f3322573056098f21575ac5080d42629e74'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'libgsf'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
