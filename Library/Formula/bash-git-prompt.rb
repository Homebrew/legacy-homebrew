require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.1.tar.gz"
  sha1 "9bd29dc2aa4859d2f4c0736cb26cc177de9c1274"
  head "https://github.com/magicmonty/bash-git-prompt.git"

  def install
    share.install "./gitprompt.sh", "./gitprompt.fish", "./git-prompt-help.sh",
                  "./git-prompt-colors.sh", "gitstatus.sh", "prompt-colors.sh"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      source #{opt_share}/gitprompt.sh
    EOS
  end
end
