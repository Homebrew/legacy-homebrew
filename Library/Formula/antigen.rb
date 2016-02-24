class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle."
  homepage "http://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/archive/v1.tar.gz"
  sha256 "6d4bd7b5d7bc3e36a23ac8feb93073b06e1e09b9100eb898f66c2e8c3f4d7847"
  head "https://github.com/zsh-users/antigen.git"

  bottle :unneeded

  def install
    share.install "antigen.zsh"
  end

  test do
    (testpath/".zshrc").write "source `brew --prefix`/share/antigen.zsh"
    system "/bin/zsh", "--login", "-i", "-c", "antigen help"
  end
end
