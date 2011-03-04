require 'formula'

class Libcroco <Formula
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/libcroco/0.6/libcroco-0.6.2.tar.bz2'
  md5 '1429c597aa4b75fc610ab3a542c99209'
  homepage 'http://www.freespiders.org/projects/libcroco/'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'intltool'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
