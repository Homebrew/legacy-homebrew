require "formula"

class ZshCompletions < Formula
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.11.0.tar.gz"
  sha1 "d6b28c9d617e821cdd27f7e20c3ee9e97c7a958b"

  head "https://github.com/zsh-users/zsh-completions.git"

  def install
    (share/"zsh-completions").install Dir["src/_*"]
  end

  def caveats
    <<-EOS.undent
    To activate these completions, add the following to your .zshrc:

      fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)

    You may also need to force rebuild `zcompdump`:

      rm -f ~/.zcompdump; compinit

    Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
    to load these completions, you may need to run this:

      chmod go-w /usr/local/share
    EOS
  end
end
