class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "http://mp3gain.sourceforge.net"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.5.2/mp3gain-1_5_2_r2-src.zip"
  version "1.5.2"
  sha256 "3378d32c8333c14f57622802f6a92b725f36ee45a6b181657b595b1b5d64260f"

  def install
    system "make"
    bin.install "mp3gain"
  end
end

