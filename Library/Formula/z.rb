require 'formula'

class Z < Formula
  homepage 'https://github.com/rupa/z'
  url 'https://github.com/rupa/z/archive/v1.8.tar.gz'
  sha1 '7906929c23743ae954df758f3828cb225a517c51'

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
