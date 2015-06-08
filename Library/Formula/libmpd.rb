require 'formula'

class Libmpd < Formula
  desc "Higher level access to MPD functions"
  homepage 'http://gmpc.wikia.com/wiki/Gnome_Music_Player_Client'
  url 'http://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz'
  sha1 'df129f15061662a6fec1b2ce19f9dbc8b7a7d1ba'

  bottle do
    cellar :any
    revision 1
    sha1 "5a352271b7ae233617fe2ce48c0fc269e3f51cbc" => :yosemite
    sha1 "6ebf0308d867a69916c532ada5633172c120e49e" => :mavericks
    sha1 "1acdd0b195f4bb35f8d35098c54c5007396b7df8" => :mountain_lion
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
