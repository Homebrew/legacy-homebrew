require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.3.tar.gz"
  sha1 "a4e692ef33b691724df6ac9582c204d31dbb853a"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.sh", "prompt-colors.sh"

    (share/"themes").install Dir["themes/*.bgptheme"], "themes/Custom.bgptemplate"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
      	GIT_PROMPT_THEME=Default
        source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
      fi
    EOS
  end
end
