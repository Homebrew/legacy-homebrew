class Libmpd < Formula
  desc "Higher level access to MPD functions"
  homepage "https://gmpc.wikia.com/wiki/Gnome_Music_Player_Client"
  url "http://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz"
  sha256 "fe20326b0d10641f71c4673fae637bf9222a96e1712f71f170fca2fc34bf7a83"

  bottle do
    cellar :any
    revision 1
    sha256 "36471b19608eea97bc9916fdb65937fbb385ade1bf43aac4c01031d3c3c1192f" => :yosemite
    sha256 "8e79457e677bf003a8e5374f1f7ccffba5ef237e577a0e0831ccb2036101b357" => :mavericks
    sha256 "85c97dbfb2a3a419495e702df451b00bf84e355d69c2e8512a54014ff702f45c" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
