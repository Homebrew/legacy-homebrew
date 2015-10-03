class Archey < Formula
  desc "Archey script for OS X"
  homepage "https://obihann.github.io/archey-osx/"
  url "https://github.com/obihann/archey-osx/archive/1.4.tar.gz"
  sha256 "323081e9f2ddb287b9199851479272ed5aedb5330a74a984dfc387fc0ceafbf6"
  head "https://github.com/obihann/archey-osx.git"

  def install
    bin.install "bin/archey"
  end

  test do
    system "#{bin}/archey"
  end
end
