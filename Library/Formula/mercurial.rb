# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial.selenic.com/"
  url "https://mercurial.selenic.com/release/mercurial-3.4.1.tar.gz"
  sha256 "7a8acf7329beda38ceea29c689212574d9a6bfffe24cf565015ea0066f7cee3f"

  bottle do
    cellar :any
    sha256 "f038a255e43c177ae362f319d0cef3e42c1bf631418de78ee13165dc48d2b9ba" => :yosemite
    sha256 "b9408e88838e05d57720735b95c8dc00efbf81f655846b29fb363895580a1daa" => :mavericks
    sha256 "a0b7d3f952aae73b8b02aff8c82c41af458babddf9c1e01118676ec1139a734b" => :mountain_lion
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
