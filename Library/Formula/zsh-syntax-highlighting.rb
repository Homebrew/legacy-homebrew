class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.2.1.tar.gz"
  sha256 "3cdf47ee613ff748230e9666c0122eca22dc05352f266fe640019c982f3ef6db"

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
