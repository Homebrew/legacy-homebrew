require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.2.tar.gz"
  sha1 "392d430b87639e7f85fde02f2b4a37cb43be9aaf"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  def install
    share.install "gitprompt.sh", "gitprompt.fish", "git-prompt-help.sh",
                  "gitstatus.sh", "prompt-colors.sh"

    (share/"themes").install Dir["themes/*.bgptheme"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
        source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
      fi
    EOS
  end
end
