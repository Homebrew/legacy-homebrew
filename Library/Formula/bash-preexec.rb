class BashPreexec < Formula
  desc "preexec and precmd functions for Bash just like Zsh."
  homepage "https://github.com/rcaloras/bash-preexec"
  url "https://github.com/rcaloras/bash-preexec/archive/0.2.3.tar.gz"
  sha256 "33fad9f4e024d4d23972ca656406bfdacecd5a2fcdf290d81bb56c14a5c8d094"

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
