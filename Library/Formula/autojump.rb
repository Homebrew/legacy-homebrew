require 'formula'

class Autojump < Formula
  homepage 'https://github.com/joelthelion/autojump/wiki'
  url 'https://github.com/downloads/joelthelion/autojump/autojump_v19.tar.gz'
  md5 '7dd928f0fb5958067c53fa196a091e53'

  head 'https://github.com/joelthelion/autojump.git'

  def install
    inreplace 'autojump.sh', '/etc/profile.d/', "#{prefix}/etc/"

    bin.install 'autojump'
    man1.install 'autojump.1'
    (prefix+'etc').install 'autojump.sh' => 'autojump'
    (prefix+'etc').install 'autojump.bash', 'autojump.zsh'
    (share+'zsh/functions').install '_j'
  end

  def caveats; <<-EOS.undent
    Add the following lines to your ~/.bash_profile or ~/.zshrc file (and
    remember to source the file to update your current session):
    if [ -f `brew --prefix`/etc/autojump ]; then
      . `brew --prefix`/etc/autojump
    fi
    EOS
  end
end
