require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.3.5.tar.gz"
  sha1 "16e1a9ab0ac711de79fd3b823138c16fadb3d5de"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.sh", "prompt-colors.sh"

    (share/"themes").install Dir["themes/*.bgptheme"], "themes/Custom.bgptemplate"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      if [ -f "$(brew --prefix bash-git-prompt)/share/gitprompt.sh" ]; then
        GIT_PROMPT_THEME=Default
        source "$(brew --prefix bash-git-prompt)/share/gitprompt.sh"
      fi
    EOS
  end
end
