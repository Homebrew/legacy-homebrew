# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.4.2.tar.gz"
  sha256 "dcc90e4a8476149ecc8af13c08202860b4c9c987a94c4f3c18b28294b6fd8ecd"

  bottle do
    cellar :any
    sha256 "0edc7a26c1db573b9d652075488c14be848d9c161d9aa56a61c63de0eb72d1f4" => :yosemite
    sha256 "ff38cae3f35feed408d5bd622cd5eee77a6623dc9d25c8e96408e87326703888" => :mavericks
    sha256 "15cad2b50ded112bdd6b0b57519fc6d236f91415c738a2cfb40370717f39e1f0" => :mountain_lion
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
