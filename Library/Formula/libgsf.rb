require 'formula'

class Libgsf < Formula
  homepage 'http://projects.gnome.org/gnumeric/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.30.tar.xz'
  sha256 'cb48c3480be4a691963548e664308f497d93c9d7bc12cf6a68d5ebae930a5b70'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
