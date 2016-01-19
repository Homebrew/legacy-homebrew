class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://mpd.wikia.com/wiki/Client:Ncmpc"
  url "http://www.musicpd.org/download/ncmpc/0/ncmpc-0.24.tar.gz"
  sha256 "1e995c3d1ba20fd235dcb319e16a244c04c52c0792564b2091487035827eeb7a"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
