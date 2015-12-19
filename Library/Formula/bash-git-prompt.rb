class BashGitPrompt < Formula
  desc "Informative, fancy bash prompt for Git users"
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.4.0.tar.gz"
  sha256 "d6f6f84e7de01c6609e2d6b98c07a72b0cb6c18a031a01361e6ea8a4b59e96d5"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  bottle :unneeded

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.py", "gitstatus.sh", "gitstatus_pre-1.7.10.sh",
                  "prompt-colors.sh"

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
