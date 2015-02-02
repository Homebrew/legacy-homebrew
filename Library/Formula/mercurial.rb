# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  homepage "http://mercurial.selenic.com/"
  url "http://mercurial.selenic.com/release/mercurial-3.3.tar.gz"
  sha1 "9bc03b6e82ce7bccb9d2608c7a5c4023adf2290c"

  bottle do
    cellar :any
    sha1 "70793c59ab9c56e13df2dfc08af7d386794ea0e6" => :yosemite
    sha1 "466d3dceb99256119196e06effd8bb18ea8accea" => :mavericks
    sha1 "5adc409dc7655f094c19f1ec1026efbde4775109" => :mountain_lion
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
