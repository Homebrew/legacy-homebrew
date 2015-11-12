class Shpotify < Formula
  desc "Command-line interface for Spotify on a Mac"
  homepage "https://harishnarayanan.org/projects/shpotify/"
  url "https://github.com/hnarayanan/shpotify/archive/1.0.0.tar.gz"
  sha256 "4bdc2bd488132604c9b9e850816db1df77ab468144972f9649316593fb4a6ac0"
  head "https://github.com/hnarayanan/shpotify.git"

  bottle :unneeded

  def install
    bin.install "spotify"
  end

  test do
    system "#{bin}/spotify"
  end
end
