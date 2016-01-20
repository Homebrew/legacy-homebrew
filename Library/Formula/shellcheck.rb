require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.3.tar.gz"
  sha256 "229a3bd5e38c4da2ce7ddf43c06ca388454e0406f3dbfc44865208b6b334109e"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "662dc25a63c76e74d5138f7163dbec440568bc5fd458103724bbb7c90a378a66" => :el_capitan
    sha256 "1ae6443452b39ff65b80c1f783b8b01069d58fa169bae7759c9eb463ca6044d7" => :yosemite
    sha256 "8a2f8d95c16dfcb2879eea5f31381620aff4f6bec812ffbb6dfb2adc7769fdfb" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build

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
    assert_match "[SC2045]", shell_output("shellcheck -f gcc #{sh}", 1)
  end
end
