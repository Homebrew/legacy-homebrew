require 'formula'

class Libmpd < Formula
  url 'http://downloads.sourceforge.net/project/musicpd/libmpd/11.8.17/libmpd-11.8.17.tar.gz'
  homepage 'http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client'
  sha1 'df129f15061662a6fec1b2ce19f9dbc8b7a7d1ba'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def options
    [[ '--universal', 'Build a universal library.' ]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
