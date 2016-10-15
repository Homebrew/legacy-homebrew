class Tortle < Formula
  desc "Tiny utility for easily enabling or disabling Tor"
  homepage "https://thrifus.github.io/Tortle"
  url "https://github.com/thrifus/Tortle/archive/1.0.3.tar.gz"
  sha256 "afe2a1a3d117e4125a4ec046e7007efde716f197bff3b60f915f30bc1cfa830f"

  depends_on "tor"

  def install
    bin.install "tortle"
  end

  test do
    system "#{bin}/tortle"
  end
end
