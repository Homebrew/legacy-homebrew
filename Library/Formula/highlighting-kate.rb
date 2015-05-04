require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.5.15/highlighting-kate-0.5.15.tar.gz"
  sha256 "e4e52471dcef0771109d1f748ca9989a32eac8a31971b7e09e1c81c6cef7e945"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "86322e2910c87ac610e02179640b08788131de9387b1e6135cdb770239471955" => :yosemite
    sha256 "1ccfc82bcd8438ea1a4bce5f6c4b78ca5964a08fc0afcdf85e8b70eb5812f17b" => :mavericks
    sha256 "58d154be3ad6c4e3aa22591ad48f20deaeb7e238633e3503f7757782dfa3f6f7" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

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
