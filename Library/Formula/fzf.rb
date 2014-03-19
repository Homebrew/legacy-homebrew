require "formula"

class Fzf < Formula
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.8.1.tar.gz"
  sha1 "c77827b6a1ca60eb8273ab20eb97c1f78c375452"

  def install
    prefix.install "install", "fzf", "fzf-completion.bash", "fzf-completion.zsh"
    bin.install_symlink prefix/"fzf"
  end

  def caveats; <<-EOS.undent
    To install useful keybindings and fuzzy completion:
      #{prefix}/install
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($/)
    `cat #{testpath/"list"} | fzf -f wld`.chomp == "world"
  end
end
