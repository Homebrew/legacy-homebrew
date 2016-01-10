require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  desc "Static analysis and lint tool, for (ba)sh scripts"
  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.4.2.tar.gz"
  sha256 "ea3eca5f2cce13ab6b4332b3cb5fb419c7ebf3f2e3d4d01c52b6cf5938aa96cf"
  head "https://github.com/koalaman/shellcheck.git"

  bottle do
    sha256 "14e1a8a2f36ddc39337d311d808be42714d61b13321d2eebf3a56652b47e92c7" => :el_capitan
    sha256 "ac1178a4fb95b1f9ce7e0306cae1092c42fc6bd790e4687ebc23b52ffab9a008" => :yosemite
    sha256 "08df00a8b3af043ffdba9b21ac77904958cb3d32d945b9a57cdda6293adbe181" => :mavericks
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
