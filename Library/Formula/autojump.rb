require 'formula'

class Autojump < Formula
  homepage 'https://github.com/joelthelion/autojump#name'
  url 'https://github.com/downloads/joelthelion/autojump/autojump_v21.0.3.tar.gz'
  sha1 'b81308d6ff50680cb74795195e93427557a938ad'

  head 'https://github.com/joelthelion/autojump.git'

  def install
    inreplace 'bin/autojump.sh', ' /etc/profile.d/', " #{prefix}/etc/"

    bin.install 'bin/autojump'
    man1.install 'docs/autojump.1'
    (prefix+'etc').install 'bin/autojump.sh', 'bin/autojump.bash', 'bin/autojump.zsh'
    (share+'zsh/site-functions').install 'bin/_j'
  end

  def caveats; <<-EOS.undent

    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):

    [[ -f `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

    EOS
  end
end
