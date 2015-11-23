class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-4.01.tar.gz"
  sha256 "0246022128890d24b926a9bd17a9d4aa89b179dc05a0fedee33fa282c0ceba5b"
  head "https://github.com/lonsig/depqbf.git"

  bottle do
    cellar :any
    sha256 "d006dbbf545986f9d193b311c5c4dc126866188bdda63c9e3eecc396a8bb9d37" => :yosemite
    sha256 "d03768d1c826f6f6b962ff7f397eac00dd4e0177abda5c520a43c1b0109b816f" => :mavericks
    sha256 "fa17129bcb7ff4927330dfa1b25148cca21681b687811962402ab142914b9edd" => :mountain_lion
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
