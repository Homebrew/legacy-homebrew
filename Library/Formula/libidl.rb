require 'formula'

class Libidl < Formula
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  url 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2'
  sha1 'abedf091bef0c7e65162111baf068dcb739ffcd3'

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
