class BashGitPrompt < Formula
  desc "Informative, fancy bash prompt for Git users"
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.4.1.tar.gz"
  sha256 "1872ff7c9512758cc2689b6e69840060785d0e5d94e079680a00bcbcf1737715"
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
