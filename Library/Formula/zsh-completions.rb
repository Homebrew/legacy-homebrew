require 'formula'

class ZshCompletions < Formula
  homepage 'https://github.com/zsh-users/zsh-completions'
  url 'https://github.com/zsh-users/zsh-completions/tarball/0.7.0'
  sha1 '604f4678b29ee1c1a0a0da11a20feef283b64822'

  head 'https://github.com/zsh-users/zsh-completions.git'

  def install
    (share/'zsh-completions').install Dir['src/_*']
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
