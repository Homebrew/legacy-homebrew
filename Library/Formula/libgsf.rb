require 'formula'

class Libgsf < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.23.tar.xz'
  homepage 'http://projects.gnome.org/gnumeric/'
  sha256 'bfc1c6178f5319d5e6d854c380ce26542f9a103a5ff31c9d25a834e0be52fb17'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'intltool'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
