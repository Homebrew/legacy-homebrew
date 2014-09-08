require 'formula'

class Libidl < Formula
  homepage 'http://ftp.acc.umu.se/pub/gnome/sources/libIDL/0.8/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2'
  sha1 'abedf091bef0c7e65162111baf068dcb739ffcd3'

  bottle do
    cellar :any
    sha1 "180ee43bd107ff66958c084e07cee49dfebe3ad8" => :mavericks
    sha1 "67b52367b3837a35a040756e9527843c7c128c7d" => :mountain_lion
    sha1 "32f78e432853dfddafed4a616f55e3dcde64ccd0" => :lion
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
