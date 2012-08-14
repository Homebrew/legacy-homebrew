require 'formula'

class ZshCompletions < Formula
  homepage 'https://github.com/zsh-users/zsh-completions'
  url 'https://github.com/zsh-users/zsh-completions/tarball/0.5.2'
  sha1 'aee4dde26e6b54c2c580380241c4c384b6d4962d'

  def install
    (share/'zsh-completions').install Dir['_*']
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
