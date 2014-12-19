require 'formula'

class Libidl < Formula
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2'
  sha1 'abedf091bef0c7e65162111baf068dcb739ffcd3'

  bottle do
    cellar :any
    revision 1
    sha1 "60164bc801b8634dc8a49a0a20feb69b3d07ecd2" => :yosemite
    sha1 "ce811907de560d4267e86a751aaae547917b821b" => :mavericks
    sha1 "b84b7a68bbfac07be00db3449ad7b9ca3baecdca" => :mountain_lion
  end

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
