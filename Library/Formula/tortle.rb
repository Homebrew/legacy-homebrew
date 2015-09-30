class Tortle < Formula
  desc "Tortle is a tiny utility for easily enabling or disabling Tor"
  homepage "https://thrifus.github.io/Tortle"
  url "https://github.com/thrifus/Tortle/archive/1.0.1.tar.gz"
  version "1.0.1"
  sha256 "825fb2f4df4026f01e54ad6a1d75b531bd9c453d372c18538d477047524215ef"

  def install
    bin.install "tortle"
  end

  test do
    system "#{bin}/tortle"
  end
end
