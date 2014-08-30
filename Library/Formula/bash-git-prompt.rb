require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.0.tar.gz"
  head "https://github.com/magicmonty/bash-git-prompt", :using => :git
  sha1 "3c0bc71302b97260cf8d14a1f01be732039365b9"

  def install
    share.install Dir["./gitprompt.{sh,fish}"]
    share.install Dir["./git-prompt-{help,colors}.sh"]
    share.install "gitstatus.sh"
    share.install "prompt-colors.sh"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    The bash-git-prompt has installed to #{HOMEBREW_PREFIX}/share/gitprompt.sh
    See also #{doc}/README.md
    EOS
  end
end
