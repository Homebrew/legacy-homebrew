require 'formula'

class Libgsf < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/libgsf/1.14/libgsf-1.14.21.tar.bz2'
  homepage 'http://projects.gnome.org/gnumeric/'
  sha256 'eef0a9d6eca4e6af6c16b208947e3c958c428b94d22792bdd0b80c08a4b301db'

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
