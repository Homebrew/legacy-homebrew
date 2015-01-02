class ZshSyntaxHighlighting < Formula
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.2.1.tar.gz"
  sha1 "767c5fff7a5823647c733091348c3c52a5c2d1b0"

  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  def install
    (share/"zsh-syntax-highlighting").install Dir["*"]
  end

  def caveats
    <<-EOS.undent
    To activate the syntax highlighting, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc

    Additionally, if your receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:

      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=#{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
    EOS
  end

  test do
    system "#{share}/zsh-syntax-highlighting/tests/test-highlighting.zsh", "main"
  end
end
