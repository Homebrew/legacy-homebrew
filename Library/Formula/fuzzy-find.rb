require 'formula'

class FuzzyFind < Formula
  desc "Fuzzy filename finder that matches across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha1 "13429471e6b51613361128e4d31f2e62013e2c2b"

  head 'https://github.com/silentbicycle/ff.git'

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
  end

  test do
    system "#{bin}/ff", "-t"
  end
end
