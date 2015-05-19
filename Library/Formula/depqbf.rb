class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-4.0.tar.gz"
  sha1 "dd7dd35aded11bb348ff9ef16626d481b7da3fe4"
  head "https://github.com/lonsig/depqbf.git"

  bottle do
    cellar :any
    sha256 "c42d2f72e7d98cb11eb2ece8767813586782fe50f8ea9b388dbec0babffce086" => :yosemite
    sha256 "8e1ce436adc6bfa7d44b41c551be876ce9ab86b89b24dd02e0bfc69b3dc24a9e" => :mavericks
    sha256 "c0731be8df5bb103dcabcd65aa8dc512a261935ce13c4db1bfe0ae8b7e1cbc56" => :mountain_lion
  end

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
