require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.2/highlighting-kate-0.6.2.tar.gz"
  sha256 "728f10ccba6dfa1604398ae527520d2debeef870472fe104c2bf0714c513b411"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "cc5f019b34a5838ef52928bbf30e42191c96ed1e1e602193e6b71cc8ddf2d5f7" => :el_capitan
    sha256 "99f8faf09ffb0852acc90e5e1f1bfbf6ec21e09fd2b1da748fd25dd960666f6d" => :yosemite
    sha256 "be3f9ad7b797304a0403bf168f4a2519c44c8a790731004ab5c6862615f90fee" => :mavericks
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
