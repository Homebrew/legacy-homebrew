class Tortle < Formula
  desc "Tiny utility for easily enabling or disabling Tor"
  homepage "https://thrifus.github.io/Tortle"
  url "https://github.com/thrifus/Tortle/archive/1.0.3.tar.gz"
  sha256 "f9cb1de7586f99b9a1aa746a7e2b7f1939179841c479b243a3c8a36eff0c3186"

  depends_on "tor"

  def install
    bin.install "tortle"
  end

  test do
    system "#{bin}/tortle"
  end
end
