require 'formula'

class Autojump < Formula
  homepage 'https://github.com/joelthelion/autojump#name'
  url 'https://github.com/joelthelion/autojump/archive/release-v21.6.9.tar.gz'
  sha1 '9d13e56ec1abf76e0e955d754e8a62616bb102a7'

  head 'https://github.com/joelthelion/autojump.git'

  def install
    inreplace 'bin/autojump.sh', ' /etc/profile.d/', " #{prefix}/etc/"

    bin.install 'bin/autojump'
    man1.install 'docs/autojump.1'
    (prefix+'etc').install 'bin/autojump.sh', 'bin/autojump.bash', 'bin/autojump.zsh'
    # add support for fish (friendly interactive shell)
    if build.head?
        (prefix+'etc').install 'bin/autojump.fish'
    end
    zsh_completion.install 'bin/_j'
  end

  def caveats;
    msg = <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):

    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    EOS
    if build.head?
        msg += <<-EOS.undent

        Add the following line to your ~/.config/fish/config.fish:

        . /usr/local/Cellar/autojump/HEAD/etc/autojump.fish
        EOS
    end
    msg
  end
end
