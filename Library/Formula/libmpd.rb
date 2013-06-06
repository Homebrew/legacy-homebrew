require 'formula'

class Libmpd < Formula
  homepage 'http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client'
  url 'http://downloads.sourceforge.net/project/musicpd/libmpd/11.8.17/libmpd-11.8.17.tar.gz'
  sha1 'df129f15061662a6fec1b2ce19f9dbc8b7a7d1ba'

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
