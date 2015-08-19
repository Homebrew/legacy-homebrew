require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.5.15/highlighting-kate-0.5.15.tar.gz"
  sha256 "e4e52471dcef0771109d1f748ca9989a32eac8a31971b7e09e1c81c6cef7e945"

  head "https://github.com/jgm/highlighting-kate.git"

  revision 1

  bottle do
    sha256 "db7a73bbcb74eb2d4842fdcf0a45d2622b55f5e8253002fcebbc72ffd9802418" => :yosemite
    sha256 "2399e5d788f4a5df5cb982391469a1ce098a2949e07edefd6360b6ebdae86ad9" => :mavericks
    sha256 "92acb3a9ceca6de37a683647f0fa16e2d2ffa2e2910bb6bdcb99afc91f589f42" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}", "-fexecutable"
    end
    cabal_clean_lib
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line = '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">*hello, world*</code></pre></div></body>'
    assert_equal expected_last_line, test_output_last_line
  end
end
