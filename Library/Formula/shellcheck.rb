require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.8.tar.gz"
  sha256 "fc13e21cc7bcf7eff57357d710a7fd4a9f0cfe059021e4dab51fe8dbdad01f79"

  bottle do
    sha256 "b684bc00716f9d9afc54245043ea4cb69c5ddc3fff7e84b1ad9534fe77c46915" => :el_capitan
    sha256 "a957e04c6bb4a108173124a332986b0a2f6c196cec2e2d58313259465f460289" => :yosemite
    sha256 "eac7dd062afbf499c2c80f069c1fdf6c88ca1b6edc8b80cf491072bdc1a9a603" => :mavericks
    sha256 "a525ca3b03619fc1a4faeed9d92cb52d470ff0cf638fc6acb349c204fb6e461c" => :mountain_lion
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
