# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.6.2.tar.gz"
  sha256 "09c567049c3e30f791db0cf5937346c7ff3568deadf4eb1d4e2f7c80001cb3d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "796ce3c914200bb5d0d75d7b8cd291a22176a9573248a49535eeba1dd6ba1ebf" => :el_capitan
    sha256 "b25d3b0840a1bfe19ab9557d8aec3c9898e91c819cf351b7b82e302a074a935b" => :yosemite
    sha256 "f8daf8b1f7644c613d4c6993cfc6a45fbb3cdfc637cf5e0f869ae458e607118a" => :mavericks
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
