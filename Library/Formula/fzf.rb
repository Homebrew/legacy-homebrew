require "formula"

class Fzf < Formula
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.8.3.tar.gz"
  sha1 "9d598e42a3dbbad7df3dfae138a759042e004307"

  def install
    prefix.install "install", "fzf", "fzf-completion.bash", "fzf-completion.zsh"
    bin.install_symlink prefix/"fzf"
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats; <<-EOS.undent
    To install useful keybindings and fuzzy completion:
      #{prefix}/install

    To use fzf in Vim, add the following line to your .vimrc:
      set rtp+=#{prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($/)
    `cat #{testpath}/list | fzf -f wld`.chomp == "world"
  end
end
