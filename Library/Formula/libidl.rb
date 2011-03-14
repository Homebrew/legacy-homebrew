require 'formula'

class Libidl < Formula
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2'
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  md5 'bb8e10a218fac793a52d404d14adedcb'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
