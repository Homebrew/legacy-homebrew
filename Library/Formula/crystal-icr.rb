class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.1.0.tar.gz"
  sha256 "f0189e16f466563b075b26ae71e81572ae120952f8f4b5571bbee41011f471c1"

  version "0.1.0"

  depends_on "crystal-lang" => :build

  def install
    system "make"
    bin.install "bin/icr"
  end
end
