class FuzzyFind < Formula
  desc "Fuzzy filename finder that matches across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha256 "104300ba16af18d60ef3c11d70d2ec2a95ddf38632d08e4f99644050db6035cb"

  head "https://github.com/silentbicycle/ff.git"

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
  end

  test do
    system "#{bin}/ff", "-t"
  end
end
