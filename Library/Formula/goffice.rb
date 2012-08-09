require 'formula'

class Goffice < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/goffice/0.8/goffice-0.8.17.tar.bz2'
  sha256 'dd8caef5fefffbc53938fa619de9f58e7c4dc71a1803de134065d42138a68c06'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'libgsf'
  depends_on 'gtk+'
  depends_on 'pcre'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
