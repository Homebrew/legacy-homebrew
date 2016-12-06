class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.2.2.tar.gz"
  sha256 "68e748308754437bad0f948cde8dd3a903ad53d919b4e0ce7b18e012895e6fa8"

  head "https://github.com/rcaloras/bash-preexec.git"

  bottle :unneeded

  def install
    (prefix/"etc/profile.d").install "bash-preexec.sh"
  end

  def caveats; <<-EOS.undent
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)

      [[ -f $(brew --prefix)/etc/profile.d/bash-preexec.sh ]] && . $(brew --prefix)/etc/profile.d/bash-preexec.sh

    EOS
  end

  test do
    # Just testing that the file is installed
    assert File.exist?("#{prefix}/etc/profile.d/bash-preexec.sh")
  end
end
