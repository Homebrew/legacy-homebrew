# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-3.6.2.tar.gz"
  sha256 "09c567049c3e30f791db0cf5937346c7ff3568deadf4eb1d4e2f7c80001cb3d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "900026208e2daf37722bb119c607310a28428b5aaa5ac05f395c34eebdb1678e" => :el_capitan
    sha256 "25ff4d69b0884dc2d314ead937ad2586a3588f7b49e997fb12a57acc43c10456" => :yosemite
    sha256 "9900e5b8264091b0d25f2dbe3cfedb837d50178379705eaad8e214dc63dd8bd5" => :mavericks
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
