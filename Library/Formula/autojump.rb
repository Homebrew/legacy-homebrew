require 'formula'

class Autojump < Formula
  homepage 'https://github.com/joelthelion/autojump#name'
  url 'https://github.com/joelthelion/autojump/archive/release-v21.1.4.tar.gz'
  sha1 '7c7035e8258cc9171a1b6a13a3ce412630070586'

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

    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    EOS
  end
end
