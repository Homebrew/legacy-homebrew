require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.7.tar.gz"
  sha256 "9f421052bc07047b65854544bfe32c5503cdad09f00d7a63a2f28b09b03a08f6"

  revision 1

  bottle do
    sha256 "99ba5b372a0b930e6cc37cbf5e859ce4343dae74761b7d889b05de7ac4c10cf5" => :yosemite
    sha256 "20ef0d5fbc32fb438b20bbb1a3a4e4b29caaecda90e99243c1b21c52dc50e9e5" => :mavericks
    sha256 "99a272616351b3dff4855d7257819222fa2179dd7735ce485115987c5f7a968b" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build

  setup_ghc_compilers

  def install
    install_cabal_package
    system "pandoc", "-s", "-t", "man", "shellcheck.1.md", "-o", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<-EOS.undent
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert `shellcheck -f gcc #{sh}`.include? "[SC2045]"
  end
end
