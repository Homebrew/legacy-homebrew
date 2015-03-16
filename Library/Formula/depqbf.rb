class Depqbf < Formula
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-4.0.tar.gz"
  sha1 "dd7dd35aded11bb348ff9ef16626d481b7da3fe4"
  head "https://github.com/lonsig/depqbf.git"

  def install
    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end
