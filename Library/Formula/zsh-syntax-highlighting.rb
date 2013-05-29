require 'formula'

class ZshSyntaxHighlighting < Formula
  homepage 'https://github.com/zsh-users/zsh-syntax-highlighting'
  url 'https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.1.3.zip'
  sha1 '889b041af29ff1aab0a8e3a3b99ba24f02ddc881'

  head 'https://github.com/zsh-users/zsh-syntax-highlighting.git'

  def install
    (share/'zsh-syntax-highlighting').install Dir['*']
  end

  def caveats
    <<-EOS.undent
    To activate the syntax highlighting, add the following AT THE END of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc

    Additionnaly, if your receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:

      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=#{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
    EOS
  end
end
