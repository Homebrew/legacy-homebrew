class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.4.0.tar.gz"
  sha256 "e38581310479646e8f4df7e572489b28b361c8332b186207685efbd90b3016f1"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9bcc98f3e4991208631d2dac684b5ed58e62095d9d075ad12c26f4086e5900a" => :el_capitan
    sha256 "064d1f67b697df90b05210abda64d87e17054f13d027f2f3d409ab3d0a01208a" => :yosemite
    sha256 "c26a6fdba485b471b9ac489c6ba67a134b494c56e3abe467789f56b7c35c7ed1" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
    assert_match "#{version}\n",
      shell_output("zsh -c '. #{share}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && echo $ZSH_HIGHLIGHT_VERSION'")
  end
end
