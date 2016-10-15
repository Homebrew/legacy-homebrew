class FishTank < Formula
  homepage "https://github.com/terlar/fish-tank"
  url "https://github.com/terlar/fish-tank/archive/0.1.1.tar.gz"
  sha1 "b0be92bf01dae05e0efced363139d0d813365485"

  head "https://github.com/terlar/fish-tank.git"

  def install
    system "make", "install"
  end
end
