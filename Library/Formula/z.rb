require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
  url 'https://github.com/rupa/z/archive/v1.6.tar.gz'
  sha1 '3efddaddb4f68b76f91e504885bb7bf524730086'

  head 'https://github.com/rupa/z.git'

  def install
    (prefix/'etc/profile.d').install 'z.sh'
    man1.install 'z.1'
  end

  def caveats; <<-EOS.undent
    For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
      . `brew --prefix`/etc/profile.d/z.sh
    EOS
  end
end
