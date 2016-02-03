# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.7.1.tar.gz"
  sha256 "96d37d1f444a032295e190318b3166e9d05abb55916d2b3adb618a8f16c5cfed"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0ddbe75dc94b3f1d0c906570967418735f3473970a55ddffa3b0bb78239d889" => :el_capitan
    sha256 "ec0eea58de3471bfb5741ad6f9e74fc19c7545df17a6af90741efdff5ae94820" => :yosemite
    sha256 "8a11d3a115c8b8b0edfc23cc605cfddeffdb3bdff3b8d2d348eb57b61c08ae13" => :mavericks
  end

  def install
    ENV.minimal_optimization if MacOS.version <= :snow_leopard

    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  test do
    system "#{bin}/hg", "init"
  end
end
