require 'formula'

class Libidl < Formula
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2'
  md5 'bb8e10a218fac793a52d404d14adedcb'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
