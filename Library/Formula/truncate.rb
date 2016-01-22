class Truncate < Formula
  desc "truncates a file to a given size"
  homepage "http://www.vanheusden.com/truncate"
  url "https://github.com/flok99/truncate/archive/0.9.tar.gz"
  sha256 "a959d50cf01a67ed1038fc7814be3c9a74b26071315349bac65e02ca23891507"
  head "https://github.com/flok99/truncate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "299b80454c20134c5d0916da25fb3d5f0b6843e620dac6babebe01a899253a69" => :el_capitan
    sha256 "a9d1c87d6cfec42674f0e7db25b786ba100a04c8c0da318fd5f6299a7418843f" => :yosemite
    sha256 "d8751674842b772bd3a5318c1234f262518d05d66a7fe3b06ce5f59b2176bba8" => :mavericks
  end

  def install
    system "make"
    bin.install "truncate"
    man1.install "truncate.1"
  end

  test do
    system "#{bin}/truncate", "-s", "1k", "testfile"
  end
end
