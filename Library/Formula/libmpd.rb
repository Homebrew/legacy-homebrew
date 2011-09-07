require 'formula'

class Libmpd < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpd/0.20.0/libmpd-0.20.0.tar.gz'
  homepage 'http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client'
  md5 '2f1c99e12c69f7d95cfd1e27368056ed'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
