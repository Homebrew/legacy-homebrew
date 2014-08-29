require "formula"

class BashGitPrompt < Formula
  homepage "https://github.com/magicmonty/bash-git-prompt"
  url "https://github.com/magicmonty/bash-git-prompt/archive/2.0.tar.gz"
  head "https://github.com/magicmonty/bash-git-prompt", :using => :git
  sha1 "3c0bc71302b97260cf8d14a1f01be732039365b9"

  def install
    prefix.install Dir['./*']
  end

  def caveats; <<-EOS.undent
    Add the following lines to your .bashrc:

    if [ -f #{prefix}/gitprompt.sh ]; then
      . #{prefix}/gitprompt.sh
    fi

    For further information see the README.md in #{prefix}
    EOS
  end
end
