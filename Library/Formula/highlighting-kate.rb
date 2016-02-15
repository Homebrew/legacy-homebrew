require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.1/highlighting-kate-0.6.1.tar.gz"
  sha256 "cb57caf861bda046043575772ffc7fd4cd21dd63a0ecdf26b624c7e930e0f30e"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "22f7ecae654b2995bc9de1063560c82e00bd9238e62cc4bf96c9c14f3e6955fd" => :el_capitan
    sha256 "6e05943301b13d727ccfdfe312c33ba616d39a331a46bf71a080bdc75b0ece33" => :yosemite
    sha256 "827a5dc67aedb86cbd829de6bc1f4b0d06168fa4f36b68fa57de0ef5d7316544" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "-f executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line = '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">*hello, world*</code></pre></div></body>'
    assert_equal expected_last_line, test_output_last_line
  end
end
