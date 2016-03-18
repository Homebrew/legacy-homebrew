class Dasht < Formula
  desc "Search API docs offline, in your terminal or browser"
  homepage "https://sunaku.github.io/dasht"
  url "https://github.com/sunaku/dasht/archive/v2.0.0.tar.gz"
  sha256 "bd058d57ecb13f95a7979e466572785fc08ede807f0558620aa4ec377f3afd72"

  bottle :unneeded

  depends_on "sqlite"
  depends_on "socat"

  def install
    bin.install Dir["bin/*"]
    man.install "man/man1"
  end

  test do
    system "#{bin}/dasht"
  end
end
