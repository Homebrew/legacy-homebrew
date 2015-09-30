class Tortle < Formula
  desc "Tortle is a tiny utility for easily enabling or disabling Tor"
  homepage "https://thrifus.github.io/Tortle"
  url "https://github.com/thrifus/homebrew/archive/1.0.2.tar.gz"
  version "1.0.2"
  sha256 "f9cb1de7586f99b9a1aa746a7e2b7f1939179841c479b243a3c8a36eff0c3186"

  depends_on "tor"
  def install
    bin.install "tortle"
  end

  test do
    system "#{bin}/tortle"
  end
end
