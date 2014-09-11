require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.0.tar.gz"
  head "https://github.com/magicmonty/bash-git-prompt", :using => :git
  sha1 "3c0bc71302b97260cf8d14a1f01be732039365b9"

  def install
    share.install Dir["./gitprompt.{sh,fish}"], Dir["./git-prompt-{help,colors}.sh"], "gitstatus.sh", "prompt-colors.sh"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc or equivalent:
    source #{opt_share}/gitprompt.sh
    EOS
  end
end
