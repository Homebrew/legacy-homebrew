class Archey < Formula
  desc "Archey script for OS X"
  homepage "https://obihann.github.io/archey-osx/"
  url "https://github.com/obihann/archey-osx/archive/v1.5.tar.gz"
  sha256 "e2206c6e46f8f1e54c865360fecc1aa71b04ef92d115f2e4cffc0a80f49fd784"
  head "https://github.com/obihann/archey-osx.git"

  def install
    bin.install "bin/archey"
  end

  test do
    system "#{bin}/archey"
  end
end
