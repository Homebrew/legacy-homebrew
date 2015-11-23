class Archey < Formula
  desc "Archey script for OS X"
  homepage "https://obihann.github.io/archey-osx/"
  url "https://github.com/obihann/archey-osx/archive/1.5.1.tar.gz"
  sha256 "eb8d6cf9c2ab59d12825a2179a97914b764e9a718ca5a678e1610ad7a80ad5b5"
  head "https://github.com/obihann/archey-osx.git"

  bottle :unneeded

  def install
    bin.install "bin/archey"
  end

  test do
    system "#{bin}/archey"
  end
end
